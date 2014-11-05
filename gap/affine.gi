##
#if not TestPackageAvailability("4ti2Interface") = fail then
#    LoadPackage("4ti2");
#fi;
##


InfoAffSgps:=NewInfoClass("InfoAffSgps");;
SetInfoLevel(InfoAffSgps,1);;


######################################################################
# Computes the set of primitive elements of an affine semigroup, that
# is, the set of elements whose factorizations are involved in the 
# minimal generators of the congruence associated to the monod 
# (generators as a monoid; not to be confused with minimal presentations
# to this end, use BettiElementsOfAffineSemigroup)
# # REQUERIMENTS: 4ti2Interface
######################################################################

#InstallGlobalFunction(PrimitiveElementsOfAffineSemigroup,function(ls)
#    local dir, filename, exec, filestream, matrix,
#				 facs, mat, trunc;# ls;


	#if not(IsAffineSemigroup(a)) then
	#	Error("The argument must be an affine semigroup");
	#fi;

	#ls:=GeneratorsAS(a);
	
#    dir := DirectoryTemporary();
#    filename := Filename( dir, "gap_4ti2_temp_matrix" );
#
#	mat:=TransposedMat(ls);
#    4ti2Interface_Write_Matrix_To_File( mat, Concatenation( filename, ".mat" ) );
#    exec := IO_FindExecutable( "graver" );
#    filestream := IO_Popen2( exec, [ filename ]);
#    while IO_ReadLine( filestream.stdout ) <> "" do od;
#    matrix := 4ti2Interface_Read_Matrix_From_File( Concatenation( filename, ".gra" ) );
#
#    trunc:=function(ls)
#		return List(ls, y->Maximum(y,0));
#	end;

#	matrix:=Set(matrix,trunc);
#    return Set(matrix, x->x*ls);
#end);


#########
#InstallGlobalFunction(ElasticityOfAffineSemigroup,
#        function(ls)
#     local dir, filename, exec, filestream, matrix,
# 				  mat, truncplus, truncminus;

# 	if not(IsHomogeneousList(ls)) then
# 		Error("The argument must be a homogeneous list.");
# 	fi;

# 	if not(ForAll(ls,IsListOfIntegersNS)) then 
# 		Error("The argument must be a list of lists of integers.");
# 	fi;

# 	if not(Length(Set(ls, Length))=1) then
# 		Error("All lists in the first argument must have the same length.");
# 	fi;
    
#     dir := DirectoryTemporary();
#     filename := Filename( dir, "gap_4ti2_temp_matrix" );

# 	mat:=TransposedMat(ls);
#     4ti2Interface_Write_Matrix_To_File( mat, Concatenation( filename, ".mat" ) );
#     exec := IO_FindExecutable( "graver" );
#     filestream := IO_Popen2( exec, [ filename ]);
#     while IO_ReadLine( filestream.stdout ) <> "" do od;
#     matrix := 4ti2Interface_Read_Matrix_From_File( Concatenation( filename, ".gra" ) );

#     truncplus:=function(ls)
# 		return Sum(List(ls, y->Maximum(y,0)));
# 	end;

#     truncminus:=function(ls)
# 		return Sum(List(ls, y->-Minimum(y,0)));
# 	end;

# 	return Maximum(Set(matrix, y->truncplus(y)/truncminus(y)));
# end);
#####





####################################################################
# Decides if the vector v belongs to the affine semigroup a
#
####################################################################
InstallMethod( \in,
        "for affine semigroups",
        [ IsHomogeneousList, IsAffineSemigroup],
        function( v, a )
    return BelongsToAffineSemigroup(v,a);
end);

InstallMethod(BelongsToAffineSemigroup,
        "To test whether an integer belongs to a numerical semigroup",
        true,
        [ IsHomogeneousList, IsAffineSemigroup and HasGeneratorsAS],100,

        function(v,a)
    local belongs, gen;
    
      #determines if an element x is in the affine semigroup 
      # spanned by gen
    belongs:=function(x,gen)
	if gen=[] then 
            return false;
	fi;
        
	if ForAll(x,i->i=0) then
            return true;
	fi;
        
	if ForAny(x,i->i<0) then
            return false;
	fi;
        
	return belongs(x-gen[1],gen) or belongs(x,gen{[2..Length(gen)]});
    end;
    
    if not(IsAffineSemigroup(a)) then
        Error("The first argument must be an affine semigroup.");
    fi;
        
    gen:=GeneratorsAS(a);
    if not(IsMatrix(Concatenation(gen,[v]))) then
        Error("The dimension of the vector and the affine semigroup do not coincide.");
    fi;
      
    return belongs(v,gen);
    
end);

#############################################################
# Computes a basis of a subgroup of Z^n with defining equations 
# Ax =0 \in Z_m1\times\Z_mt \times Z^k, k is n-length(m),
# m=[m1,...,mt]
#############################################################
InstallGlobalFunction(BasisOfGroupGivenByEquations,function(A,m)
    local n,r, AA, i, er, b, homEqToBasis;
    
    # Compute a basis of a subgroup of Z^n with defining equations Ax=0
    homEqToBasis:=function(A)
	local snf, b, r, n;
	snf:= SmithNormalFormIntegerMatTransforms(A);
	r:=snf.rank;
	n:=Length(A[1]);
	b:=TransposedMat(snf.coltrans);
	return b{[r+1..n]};
    end;

    
    if not(IsMatrix(A)) then
        Error("The first argument must be a matrix.");
    fi;
    if not(IsInt(A[1][1])) then
        Error("The first argument must be a matrix of integers.");
    fi;
        
    if not(IsListOfIntegersNS(m)) then 
        Error("The second argument must be a lists of integers.");
    fi;
    
    if not(ForAll(m,x->x>0)) then
        Error("The second argument must be a list of positive integers");
    fi;
    
    n:=Length(A[1]);
    r:=Length(A);
    AA:=ShallowCopy(TransposedMat(A));
    er:=List([1..r],_->0);
    for i in [1..Length(m)] do
        if m[i]<>0 then
            er[i]:=m[i];
            Add(AA,ShallowCopy(er));
            er[i]:=0;
        fi;
    od;
    AA:=TransposedMat(AA);

    b:=TransposedMat(homEqToBasis(AA));

    b:=b{[1..n]};
    return LLLReducedBasis(TransposedMat(b)).basis;
end);

#############################################################
#  Computes the defining equations of the group of Z^n 
#  generated by M
#  the output is [A,m] such that Ax=0 mod m are the equations
############################################################
InstallGlobalFunction(EquationsOfGroupGeneratedBy,function(M)
    local A, m, snf, nones;    

    if not(IsMatrix(M)) then
        Error("The first argument must be a matrix.");
    fi;
    if not(IsInt(M[1][1])) then
        Error("The first argument must be a matrix of integers.");
    fi;
        
    snf:=SmithNormalFormIntegerMatTransforms(M);
    A:=TransposedMat(snf.coltrans);
    m:=DiagonalOfMat(snf.normal); 
    nones:=Length(Filtered(m,x->x=1));
  
    m:=Filtered(DiagonalOfMat(snf.normal),x->x<>0);
    A:=A{[nones+1..Length(A)]};
    m:=m{[nones+1..Length(m)]};
    
    return [A,m];
end);


##############################################################
# Determines if there is a gluing of the two affine semigroups,
# and if so, returns the gluing of them; fail otherwise
##############################################################
InstallGlobalFunction(GluingOfAffineSemigroups,function(a1,a2)
    local int, d, intersectionOfSubgroups, g1, g2;
    
        
    #computes the intersection of two groups of Z^n
    # given by generators
    intersectionOfSubgroups:=function(g1,g2)
        local eq1, eq2, A, m;
        
        eq1:=EquationsOfGroupGeneratedBy(g1);
        eq2:=EquationsOfGroupGeneratedBy(g2);
        A:=Concatenation(eq1[1],eq2[1]);
        m:=Concatenation(eq1[2],eq2[2]);
        
        return BasisOfGroupGivenByEquations(A,m);
    end;
    
    if not(IsAffineSemigroup(a1)) or not(IsAffineSemigroup(a2)) then
        Error("The arguments must be affine semigroups.");
    fi;
    
    g1:=GeneratorsAS(a1);
    g2:=GeneratorsAS(a2);
    if not(IsMatrix(Concatenation(g1,g2)))then
        Error("The semigroups must have the same dimension.");
    fi;
    
    int:=intersectionOfSubgroups(g1,g2);
    if Length(int)<> 1 then 
        return false;
    fi;
    
    d:=int[1];
    if ForAny(d, i->i<0) then
        d:=-d;
    fi;
    if BelongsToAffineSemigroup(d,a1) and 
       BelongsToAffineSemigroup(d,a2) then
        return AffineSemigroup(Concatenation(g1,g2));
    fi;
    return fail;
    
end);

###################### ContejeanDevieAlgorithm

#############################################################################################
# l contains the list of coefficients of a system of linear equations. forten gives the 
#  set of minimal generators of the affine semigroup of nonnegative soultions of this equation
##############################################################################################

InstallGlobalFunction(ContejanDevieAlgorithmForEquations,function(arg)
  local  contejeanDevieAlgorithm, contejeanDevieAlgorithmWithCongruences, ls, 
         md;

  ## local functions ...
  contejeanDevieAlgorithm:= function(l)
    local solutions, m, x, explored, candidates, tmp, k,zero, lx, leq;


    Info(InfoAffSgps,1,"It is recommended that you use NormalizInterface.");

    #less than or equal to with the usual partial order
    leq:= function(v1,v2)
      local v;
      v:=v2-v1;
      return (First(v,n->n<0)=fail);
    end;

    solutions:=[];
    explored:=[];

    if not(IsMatrix(l)) then 
      Error("The argument must be a matrix.");
    fi;
    if not(IsInt(l[1][1])) then
      Error("The matrix must be of integers.");
    fi;


    m:=IdentityMat(Length(l[1]));
    zero:=List([1..Length(l)],_->0);
    candidates:=m;
    while (not(candidates=[])) do
      x:=candidates[1];
      explored:=Union([x],explored);
      candidates:=candidates{[2..Length(candidates)]};
      lx:=l*x;
      if(lx=zero) then	
        solutions:=Union([x],solutions);
        #    Print(x);
      else
        tmp:=Set(Filtered(m,n->(lx*(l*n)<0)),y->y+x);
        tmp:=Difference(tmp,explored);
        tmp:=Filtered(tmp,n->(First(solutions,y->leq(y,n))=fail));
        candidates:=Union(candidates,tmp);
      fi;
    od;
    return solutions;
  end; 

  contejeanDevieAlgorithmWithCongruences:=function(ls,md)
    local l,n,m,diag,dim,d, hil, leq, zero;


    #less than or equal to with the usual partial order
    leq:= function(v1,v2)
      local v;
      v:=v2-v1;
      return (First(v,n->n<0)=fail);
    end;

    if not(IsMatrix(ls)) then
      Error("The first argument must be a matrix.");
    fi;

    if not(IsListOfIntegersNS(md)) or ForAny(md, x->not(IsPosInt(x))) then
      Error("The second argument must be a list of positive integers.");
    fi;

    n:=Length(ls);
    dim:=Length(ls[1]);
    m:=Length(md);
    if m>n then 
      Error("There are more modulus than equations.");
    fi;

    diag:=Concatenation(md,List([1..n-m],_->0));
    d:=DiagonalMat(diag);
    l:=TransposedMat(Concatenation(TransposedMat(ls),d,-d));
    zero:=List([1..dim],_->0);

    hil:=Difference(List(contejeanDevieAlgorithm(l), x->x{[1..dim]}),[zero]);
    return hil;

    return Filtered(hil, y->Filtered(hil,x->leq(x,y))=[y]);
  end;
  ## end of local functions ...

  ls := arg[1][1];
  md := arg[1][2];
  if md = [] then
    return contejeanDevieAlgorithm(ls);
  else
    return contejeanDevieAlgorithmWithCongruences(ls,md);

  fi;
end);

  ##############################################################################################

InstallGlobalFunction(ContejanDevieAlgorithmForInequalities,function(arg)

end);