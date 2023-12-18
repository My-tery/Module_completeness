###written by 2021-7-14
#perl match_module.pl target_Knumber.txt module_path.txt result
my ($in1,$in2,$out)=@ARGV;
open IN1,$in1 or die;
open IN2,$in2 or die;
open OUT,">$out" or die;
my %hash;
my $module_name;
while (<IN1>){
	chomp;
	$hash{$_}++;
}
print OUT "module\treal block number\tblock number\n";
while (<IN2>){
	chomp;
	if (/^>/){
		$module_name=$_;
		$module_name=~s/>//;
	}
	else {
		my @ziduan=split/\s+/;
		my $block=@ziduan;
		my $rel_block=0;
		for (my $i=0;$i<@ziduan;$i++){			
			if ($ziduan[$i]=~/\+/){
				my $jia_block=1;
                                my $xiao_jia_block;
                                my $xiao_dou_block=0;
				my @add=split/,/,$ziduan[$i]; 
				my @num;       
				for (my $j=0;$j<@add;$j++){
                                	$xiao_jia_block=1;
					if ($add[$j]=~/\+/){
						my @jiahao=split/\+/,$add[$j];
						foreach my $c(@jiahao){
							unless (exists $hash{$c}){
								$xiao_jia_block=0;
							}
						}
						push @num,$xiao_jia_block;
					}
					elsif ($add[$j]=~/EK/){
#							print "$add[$j]\n";
							$add[$j]=~s/E//;
							unless (exists $hash{$add[$j]}){
                                                                $jia_block=0;
                                                        }
					}
					else {
						if (exists $hash{$add[$j]}){
							$xiao_dou_block+=1;
						}
					}
				}
				my $f=0;
				foreach $e(@num){
					if ($e>0){
						$f++;
					}
				}
				if (($f+$xiao_dou_block)*$jia_block){
					$rel_block++;
				}
			}
			else {
				if ($ziduan[$i]=~/EK/){
					my @douhao=split/,/,$ziduan[$i];
					my $douhao_block=0;
					my $EK_block=1;
					foreach my $d(@douhao){
						if ($d=~/EK/){
							$d=~s/E//;
							unless (exists $hash{$d}){
								$EK_block=0;}
						}
                                        	else{
						if  (exists $hash{$d}){
                                                $douhao_block++;}
						}
                                        }
				if ($douhao_block*$EK_block>0){
					$rel_block++;}
				}
				else {
				my @douhao=split/,/,$ziduan[$i];
				my $douhao_block=0;
				foreach my $d(@douhao){
					if (exists $hash{$d}){
						$douhao_block++;
					}
				}
				if ($douhao_block>0){
					$rel_block++;
				}
			}
		}
	}
	print OUT "$module_name\t$rel_block\t$block\n";
	}
}
close IN1;
close IN2;
close OUT;
