#!/usr/bin/env perl

# Sean Reid
# Program that reads grades from a file and prints report card
# it  will be to modify to check for the exitence
# of the first command line parameter (in @ARGV)
# and use that for the grade file if its is passed
use warnings; 

if (!-e $ARGV[0])
{
  print " 
#====ERROR====#

The input file you specified does not exist.

";
  exit;
}

$grade_file = "grades.txt";

sub avg {
   # calculate and return an average
   # for a list of numbers that is passed to this function
   my @grade_file = @_;
   	return unless @grade_file;
   	my $total;
   	foreach (@grade_file){
   		$total += $_;
   	}
   	return $total / @grade_file;
}

sub by_grade_lname{
    # subroutine that will first NUMERICALLY
    # compare the grade VALUE in a hash and then, for grades that are 
    # the same (OR clause) will sort by the alpha value (lowercase) of 
    # the student's last name
    $grades{$b} <=> $grades{$a}
    or lc($a) cmp lc($b);
}

sub by_fname{
    # subroutine that will sort results
    # by the first name (you will need to use split in here)
    (split(/, /, $a))[1] cmp (split(/, /, $b))[1];
}

# send a message and stop execution if the
# file trying to be opened does not exist, also print a list of 
# suggested files (.txt files in the directory)
if (defined $ARGV[0])
{
    open FILE, "<", $grade_file;
}
elsif (!-e $ARGV[0])
{
  print " 
#====ERROR====#

The input file you specified does not exist.

";
print "did you mean any of these .txt files?: ";
opendir(DIR, ".");
@files = grep(/\.txt$/,readdir(DIR));
closedir(DIR);

# print all the filenames in array 
foreach $file (@files) {
   print "$file\n";
}
}


# We create a while loop to read each line of the file
while($line = <FILE>){
    # Using use split and slicing to break up the name from the grades
    ($fullname, $grade_list) = split(": ", $line);
    # We use split to get an array of grades (splitting on the space)
    @grades = split(" ", $grade_list);
    # We use the full name as the key and the average of the grades as a value
    $grades{$fullname} = &avg(@grades);
}

# We sort our hash by both grade and last name then print the pairs
@sorted_by_grades_then_lname = sort by_grade_lname keys %grades;
print "== Gradebook Sorted by Grades then Last Name ==\n\n";
foreach(@sorted_by_grades_then_lname){
    printf "%-20s \t %.2f \n", $_, $grades{$_};
} 

print "\n";

# We sort our hash by first name then print the key value pairs
@sorted_by_fname = sort by_fname keys %grades;
print "== Gradebook Sorted by First Name Only ==\n\n";
foreach(@sorted_by_fname){
    printf "%-20s \t %.2f \n", $_, $grades{$_};
}
