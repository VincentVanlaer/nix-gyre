FC	    = gfortran -ffree-form
FC1         = gfortran -ffixed-form
OPTS0       = -O2 -fPIC
OPTS1       = -c $(OPTS0)
OPTS3       = $(OPTS1) $(MODLIB)
OPTL        = -o
OPTLIB      =
LAPACK      = `pkg-config --libs --cflags lapack`
LAPACK95    = ../lapack95.a
SUF         = f90

XX = 'rm' -f $@; \
        'rm' -f $@.res; \
	$(FC) $(OPTS0) -o $@ $@.$(SUF) $(OPTLIB) $(LAPACK); \
        $@ < $@.dat > $@.res; \
        'rm' -f $@

YY = $(FC) $(OPTS0) -o $@ $@.$(SUF) $(OPTLIB) $(LAPACK)

.SUFFIXES: .f90 .f .o

.$(SUF).o:
	$(FC) $(OPTS3) $<

.f.o:
	$(FC1) $(OPTS3) $<
