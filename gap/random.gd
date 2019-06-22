#############################################################################
##
#W  random.gd               Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro A. Garcia-Sanchez <pedro@ugr.es>
#W                          Jose Morais <josejoao@fc.up.pt>
##
##
#Y  Copyright 2005 by Manuel Delgado, 
#Y  Pedro Garcia-Sanchez and Jose Joao Morais
#Y  We adopt the copyright regulations of GAP as detailed in the 
#Y  copyright notice in the GAP manual.
##
#############################################################################


#############################################################################
##
#F  RandomListForNS(n,m)
##
##  Returns a set of length not greater than n of random integers in [1..m] 
##  whose GCD is 1.
##  It is used to create "random" numerical semigroups.
##
#############################################################################
DeclareGlobalFunction( "RandomListForNS" );


#############################################################################
##
#F  RandomNumericalSemigroup(n,m)
##
##  Returns a "random" numerical semigroup  with no more 
##  than n generators in [1..m].
##
#############################################################################
DeclareGlobalFunction( "RandomNumericalSemigroup" );



#############################################################################
##
#F  RandomListRepresentingSubAdditiveFunction(m, a)
##
##  Produces a list representing a subadditive function which is periodic
##  with period m (or less). When possible, the images are in [a..20*a].
##  (Otherwise, the list of possible images is enlarged.)
##
#############################################################################
DeclareGlobalFunction( "RandomListRepresentingSubAdditiveFunction" );




#############################################################################
##
#F  RandomProportionallyModularNumericalSemigroup(k)
##
##  Produces a "random" proportionally modular semigroup.
##
#############################################################################
DeclareGlobalFunction( "RandomProportionallyModularNumericalSemigroup" );



#############################################################################
##
#F  RandomModularNumericalSemigroup(k)
##
##  Produces a "random" modular semigroup.
##
#############################################################################
DeclareGlobalFunction( "RandomModularNumericalSemigroup" );

#############################################################################
##
#F  NumericalSemigroupWithRandomElementsAndFrobenius(n,mult,frob)
##
##  Produces a "random" semigroup containing (at least) <n> elements greater than or equal to <mult> and less than <frob>, choosen at random. The semigroup returned has multiplicity choosen at random but no smaller than <mult> and having Frobenius number choosen at random but not greater than <frob>.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupWithRandomElementsAndFrobenius" );

#############################################################################
##
#F RandomNumericalSemigroupWithGenus(g)
##
## Produces a pseudo-random numerical semigroup with genus g 
#############################################################################
DeclareGlobalFunction( "RandomNumericalSemigroupWithGenus" );

#############################################################################
## For affine semigroups
#############################################################################
##
#F RandomAffineSemigroupWithGenusAndDimension(g,d)
##
## Produces a pseudo-random affine semigroup with genus g in dimension d
#############################################################################
DeclareGlobalFunction( "RandomAffineSemigroupWithGenusAndDimension" );

###############################################################################
##
#F RandomAffineSemigroup
# Returns an affine semigroup generated by a random n'*d' matrix where d' (the dimension) is randomly choosen from [1..d] and n' (the number of generators) is randomly choosen from [1..n]
###########################################################################
DeclareGlobalFunction("RandomAffineSemigroup");

###############################################################################
##
#F RandomFullAffineSemigroup
# Computes the tame degree of the affine semigroup a
###########################################################################
DeclareGlobalFunction("RandomFullAffineSemigroup");

###############################################################################
# Random functions for good semigroups
#############################################################################
##
#####################################################
#F RandomGoodSemigroupWithFixedMultiplicity:=function(m,cond)
# It produces a Good Semigroup with multiplicity m and conductor bounded by cond
#####################################################
DeclareGlobalFunction("RandomGoodSemigroupWithFixedMultiplicity");