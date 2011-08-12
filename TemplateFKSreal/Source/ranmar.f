      function ran2()
c-------------------------------------------------------
c     Front to ranmar which allows user to easily
c     choose the seed.
c------------------------------------------------------
      implicit none
c
c     Arguments
c
      real*8 ran2
c
c     Local
c
      real*8 x
      integer init,ioffset,iconfig
      integer ij,kl,iseed1,iseed2

c
c     Global
c
      integer         iseed
      common /to_seed/iseed

      integer           mincfig, maxcfig
      common/to_configs/mincfig, maxcfig
c
c     Data
c
      data init /1/
      save ij, kl
c-----
c  Begin Code
c-----
      if (init .eq. 1) then
         init = 0
         if (mincfig.ne.maxcfig) then
            write (*,*)'ERROR in initialization of random seed',
     &           mincfig,maxcfig
            stop
         endif
         iconfig=mincfig
         call get_offset(ioffset)
         if (iseed .eq. 0) call get_base(iseed)
c
c     TJS 3/13/2008
c     Modified to allow for more sequences 
c     iseed can be between 0 and 31328*30081
c     before pattern repeats
c
         ij=1802+iconfig + mod(iseed,30081)
         kl=9373+(iseed/31328)+ioffset 
         write(*,'(a,i6,a3,i6)') 'Using random seed offsets',iconfig,
     &        " : ",ioffset
         write(*,*) ' with seed', iseed
         do while (ij .gt. 31328)
            ij = ij - 31328
         enddo
         do while (kl .gt. 30081)
            kl = kl - 30081
         enddo
        call rmarin(ij,kl)         
      endif
      call ranmar(x)
      do while (x .lt. 1d-16)
         call ranmar(x)
      enddo
      ran2=x
      end




      subroutine ntuple(x,a,b,ii,jconfig)
c-------------------------------------------------------
c     Front to ranmar which allows user to easily
c     choose the seed.
c------------------------------------------------------
      implicit none
c
c     Arguments
c
      double precision x,a,b
      integer ii,jconfig
c
c     Local
c
      integer init, ioffset
      integer     ij, kl, iseed1,iseed2

c
c     Global
c
      integer         iseed
      common /to_seed/iseed
c
c     Data
c
      data init /1/
      save ij, kl
c-----
c  Begin Code
c-----
      if (init .eq. 1) then
         init = 0
         call get_offset(ioffset)
         if (iseed .eq. 0) call get_base(iseed)
c
c     TJS 3/13/2008
c     Modified to allow for more sequences 
c     iseed can be between 0 and 31328*30081
c     before pattern repeats
c
         ij=1802+jconfig + mod(iseed,30081)
         kl=9373+(iseed/31328)+ioffset 
         write(*,'(a,i6,a3,i6)') 'Using random seed offsets',jconfig," : ",ioffset
         write(*,*) ' with seed', iseed
         do while (ij .gt. 31328)
            ij = ij - 31328
         enddo
         do while (kl .gt. 30081)
            kl = kl - 30081
         enddo
        call rmarin(ij,kl)         
      endif
      call ranmar(x)
      do while (x .lt. 1d-16)
         call ranmar(x)
      enddo
      x = a+x*(b-a)
      end

      subroutine get_base(iseed)
c-------------------------------------------------------
c     Looks for file iproc.dat to offset random number gen
c------------------------------------------------------
      implicit none
c
c     Constants
c
      integer    lun
      parameter (lun=22)
c
c     Arguments
c
      integer iseed
c
c     Local
c
      character*60 fname
      logical done
      integer i,level
c-----
c  Begin Code
c-----

      fname = 'randinit'
      done = .false.
      level = 1
      do while(.not. done .and. level .lt. 5)
         open(unit=lun,file=fname,status='old',err=15)
         done = .true.
 15      level = level+1
         fname = '../' // fname
         i=index(fname,' ')
         if (i .gt. 0) fname=fname(1:i-1)
      enddo
      if (done) then
         read(lun,'(a)',end=24,err=24) fname
         i = index(fname,'=')
         if (i .gt. 0) fname=fname(i+1:)
         read(fname,*,err=26,end=26) iseed
 24      close(lun)
c         write(*,*) 'Read iseed from randinit ',iseed
         return
 26      close(lun)
      endif
 25   iseed = 0
c      write(*,*) 'No base found using iseed=0'
      end

      subroutine get_offset(iseed)
c-------------------------------------------------------
c     Looks for file iproc.dat to offset random number gen
c------------------------------------------------------
      implicit none
c
c     Constants
c
      integer    lun
      parameter (lun=22)
c
c     Arguments
c
      integer iseed
c
c     Local
c
c-----
c  Begin Code
c-----

      open(unit=lun,file='./iproc.dat',status='old',err=15)
         read(lun,*,err=14) iseed
         close(lun)
         return
 14   close(lun)
 15   open(unit=lun,file='../iproc.dat',status='old',err=25)
         read(lun,*,err=24) iseed
         close(lun)
         return
 24   close(lun)
 25   iseed = 0
      end

      subroutine ranmar(rvec)
*     -----------------
* universal random number generator proposed by marsaglia and zaman
* in report fsu-scri-87-50
* in this version rvec is a double precision variable.
      implicit real*8(a-h,o-z)
      common/ raset1 / ranu(97),ranc,rancd,rancm
      common/ raset2 / iranmr,jranmr
      save /raset1/,/raset2/
      uni = ranu(iranmr) - ranu(jranmr)
      if(uni .lt. 0d0) uni = uni + 1d0
      ranu(iranmr) = uni
      iranmr = iranmr - 1
      jranmr = jranmr - 1
      if(iranmr .eq. 0) iranmr = 97
      if(jranmr .eq. 0) jranmr = 97
      ranc = ranc - rancd
      if(ranc .lt. 0d0) ranc = ranc + rancm
      uni = uni - ranc
      if(uni .lt. 0d0) uni = uni + 1d0
      rvec = uni
      end
 
      subroutine rmarin(ij,kl)
*     -----------------
* initializing routine for ranmar, must be called before generating
* any pseudorandom numbers with ranmar. the input values should be in
* the ranges 0<=ij<=31328 ; 0<=kl<=30081
      implicit real*8(a-h,o-z)
      common/ raset1 / ranu(97),ranc,rancd,rancm
      common/ raset2 / iranmr,jranmr
      save /raset1/,/raset2/
* this shows correspondence between the simplified input seeds ij, kl
* and the original marsaglia-zaman seeds i,j,k,l.
* to get the standard values in the marsaglia-zaman paper (i=12,j=34
* k=56,l=78) put ij=1802, kl=9373
      write(*,*) "Ranmar initialization seeds",ij,kl
      i = mod( ij/177 , 177 ) + 2
      j = mod( ij     , 177 ) + 2
      k = mod( kl/169 , 178 ) + 1
      l = mod( kl     , 169 )
      do 300 ii = 1 , 97
        s =  0d0
        t = .5d0
        do 200 jj = 1 , 24
          m = mod( mod(i*j,179)*k , 179 )
          i = j
          j = k
          k = m
          l = mod( 53*l+1 , 169 )
          if(mod(l*m,64) .ge. 32) s = s + t
          t = .5d0*t
  200   continue
        ranu(ii) = s
  300 continue
      ranc  =   362436d0 / 16777216d0
      rancd =  7654321d0 / 16777216d0
      rancm = 16777213d0 / 16777216d0
      iranmr = 97
      jranmr = 33
      end