test_NcdfReader <- function() {
  file <- tempfile()
  simulateGenotypeMatrix(n.snps=10, n.chromosomes=26,
                         n.samples=20, filename=file, file.type="ncdf")
  obj <- NcdfReader(file)
  checkTrue(hasVariable(obj, "genotype"))
  checkTrue(hasCoordVariable(obj, "snp"))
  nsnp <- 100L
  nsamp <- 10L
  geno <- getVariable(obj, "genotype", start=c(1,1), count=c(nsnp,nsamp))
  checkIdentical(c(nsnp,nsamp), dim(geno))
  checkIdentical(getVariable(obj, "genotype"),
                 getVariable(obj, "genotype", start=c(1,1), count=c(-1,-1)))
  
  checkTrue(!hasVariable(obj, "foo"))
  checkIdentical(NULL, getVariable(obj, "foo"))

  # check data types
  checkTrue(is(getVariable(obj, "snp"), "vector"))
  checkTrue(is(geno, "matrix"))

  # check dimensions
  checkIdentical(dim(getVariable(obj, "genotype")), getDimension(obj, "genotype"))
  checkIdentical(c("snp","sample"), getDimensionNames(obj, "genotype"))

  # check drop
  checkIdentical(geno[1,,drop=FALSE], 
                 getVariable(obj, "genotype", start=c(1,1), count=c(1,nsamp), drop=FALSE))
  checkIdentical(geno[,1,drop=FALSE], 
                 getVariable(obj, "genotype", start=c(1,1), count=c(nsnp,1), drop=FALSE))
  
  close(obj)
  unlink(file)
  
  # file errors
  checkException(NcdfReader())
  checkException(NcdfReader("foo"))
}
