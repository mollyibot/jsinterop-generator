#!/bin/bash
#
# The script consumes the output of the jsinterop generator, splits it into
# several java files and then zips them into a srcjar file.
#
# The output of the generator is a text file containing the content of several
# files separated by =====
# The first file part contains the log emitted by the generator.
# The last file part contains informations on generated types.
# The other parts represent the java files generated by the generator.
set -e

java_files_directory=$1
generator_result_file=`pwd`/$2
tmp_files_directory=$3
output_file=$4
types_file=$5
jar=$6

# pattern used to separate java file contents in the generator's output
pattern='====='

mkdir -p $tmp_files_directory

cd $tmp_files_directory

# count the number of files
repetition=$((`grep -c $pattern $generator_result_file` - 1))
number_decimal=$((repetition + 2)) # csplit will create (repetition + 2) files
number_decimal=${#number_decimal}

# split the output file in several files
csplit -n $number_decimal -ks $generator_result_file /$pattern/ {$repetition}

cd -

# TODO(dramaix): maybe emit logs in its own file instead of skipping it.
# Compute the name of the first file.
log_file=${tmp_files_directory}/xx
for ((i=0; i<number_decimal; i++)); do
  log_file=${log_file}0
done


# loop on temporary files created by csplit
for tmp_file in $tmp_files_directory/*; do
  # Skip file containing logs for now
  if [ "$tmp_file" != "$log_file" ]; then
    # Each file (excepted the first one) is formatted like this:
    #
    # 1. =====
    # 2. package directory
    # 3. file name
    # 4. file content
    # ...

    # extract the name of the file
    filename=`sed '3q;d' $tmp_file`

    # file containing types mapping should not be included in the jar file
    if [ "$filename" = "types.txt" ]; then
      destination=$types_file
    else
      # extract the package directory and ensure it exists
      pckg=`sed '2q;d' $tmp_file`
      package_directory=${java_files_directory}${pckg}

      mkdir -p $package_directory

      destination=${package_directory}/${filename}
    fi

    # output the content of the file in correct destination
    sed -n '4,$p' $tmp_file > "$destination"
  fi
done

# create src jar file
$jar -cf $output_file -C $1 .
