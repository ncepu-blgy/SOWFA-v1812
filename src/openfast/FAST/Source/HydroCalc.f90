!jmj Start of proposed change.  v6.02a-jmj  25-Aug-2006.
!jmj Add an undocumented feature for modeling the hydrodynamic loading and
!jmj   mooring system dynamics for floating wind turbines.  Do this by allowing
!jmj   a keyword in place of the integers 0 or 1 in input PtfmLdMod when
!jmj   PtfmModel = 3:
!jmj Also, add an undocumented feature for modeling the hydrodynamic loading on
!jmj   a monopile.  Do this by reading in addition inputs from the platform
!jmj   file if they exist:
!=======================================================================
!bjj start of proposed change     6.02d-bjj
!we're linking with NWTC_Library so this is not needed
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rmMODULE InterpSubs
!rm
!rm
!rm   ! This MODULE stores generic routines for interpolation.
!rm
!rm
!rmCONTAINS
!rm!=======================================================================
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   FUNCTION InterpStp( XVal, XAry, YAry, Ind, AryLen )
!rm
!rm
!rm      ! This funtion returns a y-value that corresponds to an input x-value by interpolating into the arrays.
!rm      ! It uses the passed index as the starting point and does a stepwise interpolation from there.  This is
!rm      ! especially useful when the calling routines save the value from the last time this routine was called
!rm      ! for a given case where XVal does not change much from call to call.  When there is no correlation
!rm      ! from one interpolation to another, InterpBin() may be a better choice.
!rm      ! It returns the first or last YAry() value if XVal is outside the limits of XAry().
!rm      ! NOTE: This FUNCTION is virtually a copy of FUNCTION InterpStp()
!rm      !       from the NWTC Subroutine Library.  A few unused things have
!rm      !       been eliminated (indicated by "!remove").
!rm
!rm
!rm   !removedUSE                             NWTC_Gen
!rm   USE                             Precision
!rm
!rm   IMPLICIT                        NONE
!rm
!rm
!rm      ! Function declaration.
!rm
!rm   REAL(ReKi)                   :: InterpStp                                       ! This function.
!rm
!rm
!rm      ! Argument declarations.
!rm
!rm   INTEGER, INTENT(IN)          :: AryLen                                          ! Length of the arrays.
!rm   INTEGER, INTENT(INOUT)       :: Ind                                             ! Initial and final index into the arrays.
!rm
!rm   REAL(ReKi), INTENT(IN)       :: XAry    (AryLen)                                ! Array of X values to be interpolated.
!rm   REAL(ReKi), INTENT(IN)       :: XVal                                            ! X value to be interpolated.
!rm   REAL(ReKi), INTENT(IN)       :: YAry    (AryLen)                                ! Array of Y values to be interpolated.
!rm
!rm
!rm
!rm      ! Let's check the limits first.
!rm
!rm   IF ( XVal <= XAry(1) )  THEN
!rm      InterpStp = YAry(1)
!rm      Ind       = 1
!rm      RETURN
!rm   ELSEIF ( XVal >= XAry(AryLen) )  THEN
!rm      InterpStp = YAry(AryLen)
!rm      Ind       = AryLen - 1
!rm      RETURN
!rm   ENDIF
!rm
!rm
!rm     ! Let's interpolate!
!rm
!rm   Ind = MAX( MIN( Ind, AryLen-1 ), 1 )
!rm
!rm   DO
!rm
!rm      IF ( XVal < XAry(Ind) )  THEN
!rm
!rm         Ind = Ind - 1
!rm
!rm      ELSEIF ( XVal >= XAry(Ind+1) )  THEN
!rm
!rm         Ind = Ind + 1
!rm
!rm      ELSE
!rm
!rm         InterpStp = ( YAry(Ind+1) - YAry(Ind) )*( XVal - XAry(Ind) )/( XAry(Ind+1) - XAry(Ind) ) + YAry(Ind)
!rm         RETURN
!rm
!rm      ENDIF
!rm
!rm   ENDDO
!rm
!rm
!rm   RETURN
!rm   END FUNCTION InterpStp ! ( XVal, XAry, YAry, Ind, AryLen )
!rm   !=======================================================================
!rm   FUNCTION InterpStp_CMPLX( XVal, XAry, YAry, Ind, AryLen )
!rm
!rm
!rm      ! This funtion returns a y-value that corresponds to an input x-value by interpolating into the arrays.
!rm      ! It uses the passed index as the starting point and does a stepwise interpolation from there.  This is
!rm      ! especially useful when the calling routines save the value from the last time this routine was called
!rm      ! for a given case where XVal does not change much from call to call.  When there is no correlation
!rm      ! from one interpolation to another, InterpBin() may be a better choice.
!rm      ! It returns the first or last YAry() value if XVal is outside the limits of XAry().
!rm      ! NOTE: This FUNCTION is virtually a copy of FUNCTION InterpStp()
!rm      !       from the NWTC Subroutine Library.  A few unused things have
!rm      !       been eliminated (indicated by "!remove").
!rm
!rm
!rm   !removedUSE                             NWTC_Gen
!rm   USE                             Precision
!rm
!rm   IMPLICIT                        NONE
!rm
!rm
!rm      ! Function declaration.
!rm
!rm   !removeREAL(ReKi)                   :: InterpStp                                       ! This function.
!rm   COMPLEX(ReKi)                :: InterpStp_CMPLX                                 ! This function.
!rm
!rm
!rm      ! Argument declarations.
!rm
!rm   INTEGER, INTENT(IN)          :: AryLen                                          ! Length of the arrays.
!rm   INTEGER, INTENT(INOUT)       :: Ind                                             ! Initial and final index into the arrays.
!rm
!rm   REAL(ReKi), INTENT(IN)       :: XAry    (AryLen)                                ! Array of X values to be interpolated.
!rm   REAL(ReKi), INTENT(IN)       :: XVal                                            ! X value to be interpolated.
!rm   !removeREAL(ReKi), INTENT(IN)       :: YAry    (AryLen)                                ! Array of Y values to be interpolated.
!rm   COMPLEX(ReKi), INTENT(IN)    :: YAry    (AryLen)                                ! Array of Y values to be interpolated.
!rm
!rm
!rm
!rm      ! Let's check the limits first.
!rm
!rm   IF ( XVal <= XAry(1) )  THEN
!rm   !remove   InterpStp = YAry(1)
!rm      InterpStp_CMPLX = YAry(1)
!rm      Ind       = 1
!rm      RETURN
!rm   ELSEIF ( XVal >= XAry(AryLen) )  THEN
!rm   !remove   InterpStp = YAry(AryLen)
!rm      InterpStp_CMPLX = YAry(AryLen)
!rm      Ind       = AryLen - 1
!rm      RETURN
!rm   ENDIF
!rm
!rm
!rm     ! Let's interpolate!
!rm
!rm   Ind = MAX( MIN( Ind, AryLen-1 ), 1 )
!rm
!rm   DO
!rm
!rm      IF ( XVal < XAry(Ind) )  THEN
!rm
!rm         Ind = Ind - 1
!rm
!rm      ELSEIF ( XVal >= XAry(Ind+1) )  THEN
!rm
!rm         Ind = Ind + 1
!rm
!rm      ELSE
!rm
!rm   !remove      InterpStp = ( YAry(Ind+1) - YAry(Ind) )*( XVal - XAry(Ind) )/( XAry(Ind+1) - XAry(Ind) ) + YAry(Ind)
!rm         InterpStp_CMPLX = ( YAry(Ind+1) - YAry(Ind) )*( XVal - XAry(Ind) )/( XAry(Ind+1) - XAry(Ind) ) + YAry(Ind)
!rm         RETURN
!rm
!rm      ENDIF
!rm
!rm   ENDDO
!rm
!rm
!rm   RETURN
!rm   END FUNCTION InterpStp_CMPLX ! ( XVal, XAry, YAry, Ind, AryLen )
!rm!=======================================================================
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rmEND MODULE InterpSubs
!rm!=======================================================================
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!bjj end of proposed change
MODULE Waves


   ! This MODULE stores variables and routines associated with incident
   ! waves and current.

!bjj start of proposed change 6.02d-bjj
!rmUSE                             Precision
USE                             NWTC_Library

IMPLICIT                        NONE
!bjj end of proposed change


COMPLEX(ReKi), PARAMETER     :: ImagNmbr = (0.0,1.0)                            ! The imaginary number, SQRT(-1.0)
COMPLEX(ReKi), ALLOCATABLE   :: WaveElevC0(:)                                   ! Fourier transform of the instantaneous elevation of incident waves at the platform reference point (m-s)

!bjj rm NWTC_Library:REAL(ReKi), PARAMETER        :: D2R      =  0.017453293                         ! Factor to convert degrees to radians.
REAL(ReKi), ALLOCATABLE      :: DZNodes   (:)                                   ! Length of variable-length tower or platform elements for the points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (meters)
REAL(ReKi)                   :: Gravity                                         ! Gravitational acceleration (m/s^2)
REAL(ReKi), PARAMETER        :: Inv2Pi   =  0.15915494                          ! 0.5/Pi.
!bjj rm NWTC_Library:REAL(ReKi), PARAMETER        :: Pi       =  3.1415927                           ! Ratio of a circle's circumference to its diameter.
REAL(ReKi), PARAMETER        :: PiOvr4   =  0.78539816                          ! Pi/4.
REAL(ReKi)                   :: RhoXg                                           ! = WtrDens*Gravity
!bjj rm NWTC_Library:REAL(ReKi), PARAMETER        :: TwoPi    =  6.2831853                           ! 2*Pi.
REAL(ReKi), ALLOCATABLE      :: WaveAcc0  (:,:,:)                               ! Instantaneous acceleration of incident waves in the xi- (1), yi- (2), and zi- (3) directions, respectively, accounting for stretching, at each of the NWaveKin0 points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (m/s^2)
REAL(ReKi)                   :: WaveDir                                         ! Incident wave propagation heading direction (degrees)
REAL(ReKi)                   :: WaveDOmega                                      ! Frequency step for incident wave calculations (rad/s)
REAL(ReKi), ALLOCATABLE      :: WaveElev  (:,:)                                 ! Instantaneous elevation of incident waves at each of the NWaveElev points where the incident wave elevations can be output (meters)
REAL(ReKi), ALLOCATABLE      :: WaveElev0 (:)                                   ! Instantaneous elevation of incident waves at the platform reference point (meters)
REAL(ReKi), ALLOCATABLE      :: WaveKinzi0(:)                                   ! zi-coordinates for points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed; these are relative to the mean see level (meters)
REAL(ReKi), ALLOCATABLE      :: WaveTime  (:)                                   ! Simulation times at which the instantaneous elevation of, velocity of, acceleration of, and loads associated with the incident waves are determined (sec)
REAL(ReKi), ALLOCATABLE      :: WaveVel0  (:,:,:)                               ! Instantaneous velocity     of incident waves in the xi- (1), yi- (2), and zi- (3) directions, respectively, accounting for stretching, at each of the NWaveKin0 points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (m/s  ) (The values include both the velocity of incident waves and the velocity of current.)
REAL(ReKi)                   :: WtrDens                                         ! Water density (kg/m^3)
REAL(ReKi)                   :: WtrDpth                                         ! Water depth (meters)

INTEGER(4)                   :: NStepWave                                       ! Total number of frequency components = total number of time steps in the incident wave (-)
INTEGER(4)                   :: NStepWave2                                      ! NStepWave/2
INTEGER(4)                   :: NWaveElev                                       ! Number of points where the incident wave elevation can be output (-)
INTEGER(4)                   :: NWaveKin0                                       ! Number of points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (-)
INTEGER(4)                   :: WaveMod                                         ! Incident wave kinematics model {0: none=still water, 1: plane progressive (regular), 2: JONSWAP/Pierson-Moskowitz spectrum (irregular), 3: user-defind spectrum from routine UserWaveSpctrm (irregular)}
INTEGER(4)                   :: WaveStMod                                       ! Model for stretching incident wave kinematics to instantaneous free surface {0: none=no stretching, 1: vertical stretching, 2: extrapolation stretching, 3: Wheeler stretching}
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:

CHARACTER(1024)              :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.


CONTAINS
!=======================================================================
   SUBROUTINE InitWaves ( WtrDensIn  , WtrDpthIn   , WaveModIn, WaveStModIn, &
                          WaveTMaxIn , WaveDT      , WaveHs   , WaveTp     , &
                          WavePkShp  , WaveDirIn   , WaveSeed , GHWvFile   , &
                          CurrMod    , CurrSSV0    , CurrSSDir, CurrNSRef  , &
                          CurrNSV0   , CurrNSDir   , CurrDIV  , CurrDIDir  , &
                          NWaveKin0In, WaveKinzi0In, DZNodesIn, NWaveElevIn, &
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!remove6.02b                          WaveElevxi , WaveElevyi  , GravityIn, DirRoot        )
                          WaveElevxi , WaveElevyi  , GravityIn, DirRootIn      )
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.


      ! This routine is used to initialize the variables associated with
      ! incident waves and current.


   USE                             FFT_Module
!bjj start of proposed change 6.02d-bjj
!these are replaced by the NWTC library
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm   USE                             InterpSubs
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   USE                             Precision
!bjj end of proposed change

   IMPLICIT                        NONE


      ! Passed Variables:

   INTEGER(4), INTENT(IN )      :: NWaveElevIn                                     ! Number of points where the incident wave elevations can be output (-)
   INTEGER(4), INTENT(IN )      :: NWaveKin0In                                     ! Number of points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (-)

   REAL(ReKi), INTENT(IN )      :: CurrDIDir                                       ! Depth-independent current heading direction (degrees)
   REAL(ReKi), INTENT(IN )      :: CurrDIV                                         ! Depth-independent current velocity (m/s)
   REAL(ReKi), INTENT(IN )      :: CurrNSDir                                       ! Near-surface current heading direction (degrees)
   REAL(ReKi), INTENT(IN )      :: CurrNSRef                                       ! Near-surface current reference depth (meters)
   REAL(ReKi), INTENT(IN )      :: CurrNSV0                                        ! Near-surface current velocity at still water level (m/s)
   REAL(ReKi), INTENT(IN )      :: CurrSSDir                                       ! Sub-surface current heading direction (degrees)
   REAL(ReKi), INTENT(IN )      :: CurrSSV0                                        ! Sub-surface current velocity at still water level (m/s)
   REAL(ReKi), INTENT(IN )      :: DZNodesIn   (NWaveKin0In)                       ! Length of variable-length tower or platform elements for the points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (meters)
   REAL(ReKi), INTENT(IN )      :: GravityIn                                       ! Gravitational acceleration (m/s^2)
   REAL(ReKi), INTENT(IN )      :: WaveDirIn                                       ! Incident wave propagation heading direction (degrees)
   REAL(ReKi), INTENT(IN )      :: WaveDT                                          ! Time step for incident wave calculations (sec)
   REAL(ReKi), INTENT(IN )      :: WaveElevxi  (NWaveElevIn)                       ! xi-coordinates for points where the incident wave elevations can be output (meters)
   REAL(ReKi), INTENT(IN )      :: WaveElevyi  (NWaveElevIn)                       ! yi-coordinates for points where the incident wave elevations can be output (meters)
   REAL(ReKi), INTENT(IN )      :: WaveKinzi0In(NWaveKin0In)                       ! zi-coordinates for points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed; these are relative to the mean see level (meters)
   REAL(ReKi), INTENT(IN )      :: WaveHs                                          ! Significant wave height of incident waves (meters)
   REAL(ReKi), INTENT(IN )      :: WavePkShp                                       ! Peak shape parameter of incident wave spectrum [1.0 for Pierson-Moskowitz] (-)
   REAL(ReKi), INTENT(IN )      :: WaveTMaxIn                                      ! Analysis time for incident wave calculations; the actual analysis time may be larger than this value in order for the maintain an effecient FFT (sec)
   REAL(ReKi), INTENT(IN )      :: WaveTp                                          ! Peak spectral period of incident waves (sec)
   REAL(ReKi), INTENT(IN )      :: WtrDensIn                                       ! Water density (kg/m^3)
   REAL(ReKi), INTENT(IN )      :: WtrDpthIn                                       ! Water depth (meters)

   INTEGER(4), INTENT(IN )      :: CurrMod                                         ! Current profile model {0: none=no current, 1: standard, 2: user-defined from routine UserCurrent}
   INTEGER(4), INTENT(IN )      :: WaveStModIn                                     ! Model for stretching incident wave kinematics to instantaneous free surface {0: none=no stretching, 1: vertical stretching, 2: extrapolation stretching, 3: Wheeler stretching}
   INTEGER(4), INTENT(IN )      :: WaveModIn                                       ! Incident wave kinematics model {0: none=still water, 1: plane progressive (regular), 2: JONSWAP/Pierson-Moskowitz spectrum (irregular), 3: user-defind spectrum from routine UserWaveSpctrm (irregular)}
   INTEGER(4), INTENT(IN )      :: WaveSeed    (2)                                 ! Random seeds of incident waves [-2147483648 to 2147483647]

!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!remove6.02b   CHARACTER(1024), INTENT(IN ) :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.
   CHARACTER(1024), INTENT(IN ) :: DirRootIn                                       ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
!bjj start of proposed change v6.02d-bjj
!rm   CHARACTER(  99), INTENT(IN ) :: GHWvFile                                        ! The root name of GH Bladed files containing wave data.
   CHARACTER(1024), INTENT(IN ) :: GHWvFile                                        ! The root name of GH Bladed files containing wave data.
!bjj end of proposed change v6.02d-bjj


      ! Local Variables:

   COMPLEX(ReKi)                :: ImagOmega                                       ! = ImagNmbr*Omega (rad/s)
   COMPLEX(ReKi), ALLOCATABLE   :: PWaveAccC0HPz0 (:)                              ! Partial derivative of WaveAccC0H(:) with respect to zi at zi = 0 (1/s)
   COMPLEX(ReKi), ALLOCATABLE   :: PWaveAccC0VPz0 (:)                              ! Partial derivative of WaveAccC0V(:) with respect to zi at zi = 0 (1/s)
   COMPLEX(ReKi), ALLOCATABLE   :: PWaveVelC0HPz0 (:)                              ! Partial derivative of WaveVelC0H(:) with respect to zi at zi = 0 (-  )
   COMPLEX(ReKi), ALLOCATABLE   :: PWaveVelC0VPz0 (:)                              ! Partial derivative of WaveVelC0V(:) with respect to zi at zi = 0 (-  )
   COMPLEX(ReKi), ALLOCATABLE   :: WaveAccC0H(:,:)                                 ! Fourier transform of the instantaneous horizontal acceleration of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s)
   COMPLEX(ReKi), ALLOCATABLE   :: WaveAccC0V(:,:)                                 ! Fourier transform of the instantaneous vertical   acceleration of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s)
   COMPLEX(ReKi), ALLOCATABLE   :: WaveElevC (:,:)                                 ! Fourier transform of the instantaneous elevation of incident waves (m-s)
   COMPLEX(ReKi), ALLOCATABLE   :: WaveVelC0H(:,:)                                 ! Fourier transform of the instantaneous horizontal velocity     of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (meters)
   COMPLEX(ReKi), ALLOCATABLE   :: WaveVelC0V(:,:)                                 ! Fourier transform of the instantaneous vertical   velocity     of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (meters)
   COMPLEX(ReKi)                :: WGNC                                            ! Fourier transform of the realization of a White Gaussian Noise (WGN) time series process with unit variance for the current frequency component (SQRT(sec))

   REAL(ReKi)                   :: CurrVxi                                         ! xi-component of the current velocity at the instantaneous elevation (m/s)
   REAL(ReKi)                   :: CurrVyi                                         ! yi-component of the current velocity at the instantaneous elevation (m/s)
   REAL(ReKi)                   :: CurrVxi0                                        ! xi-component of the current velocity at zi =  0.0 meters            (m/s)
   REAL(ReKi)                   :: CurrVyi0                                        ! yi-component of the current velocity at zi =  0.0 meters            (m/s)
   REAL(ReKi)                   :: CurrVxiS                                        ! xi-component of the current velocity at zi = -SmllNmbr meters       (m/s)
   REAL(ReKi)                   :: CurrVyiS                                        ! yi-component of the current velocity at zi = -SmllNmbr meters       (m/s)
   REAL(ReKi)                   :: CWaveDir                                        ! COS( WaveDir )
   REAL(ReKi)                   :: GHQBar                                          ! Unused instantaneous dynamic pressure of incident waves in GH Bladed wave data files (N/m^2)
   REAL(ReKi), ALLOCATABLE      :: GHWaveAcc (:,:)                                 ! Instantaneous acceleration of incident waves in the xi- (1), yi- (2), and zi- (3) directions, respectively, at each of the GHNWvDpth vertical locations in GH Bladed wave data files (m/s^2)
   REAL(ReKi)                   :: GHWaveTime                                      ! Instantaneous simulation times in GH Bladed wave data files (sec)
   REAL(ReKi), ALLOCATABLE      :: GHWaveVel (:,:)                                 ! Instantaneous velocity     of incident waves in the xi- (1), yi- (2), and zi- (3) directions, respectively, at each of the GHNWvDpth vertical locations in GH Bladed wave data files (m/s  )
   REAL(ReKi), ALLOCATABLE      :: GHWvDpth  (:)                                   ! Vertical locations in GH Bladed wave data files.
   REAL(ReKi), PARAMETER        :: n_Massel = 3.0                                  ! Factor used to the scale the peak spectral frequency in order to find the cut-off frequency based on the suggestion in: Massel, S. R., Ocean Surface Waves: Their Physics and Prediction, Advanced Series on Ocean Engineering - Vol. 11, World Scientific Publishing, Singapore - New Jersey - London - Hong Kong, 1996.  This reference recommends n_Massel > 3.0 (higher for higher-order wave kinemetics); the ">" designation is accounted for by checking if ( Omega > OmegaCutOff ).
   REAL(ReKi)                   :: Omega                                           ! Wave frequency (rad/s)
   REAL(ReKi)                   :: OmegaCutOff                                     ! Cut-off frequency or upper frequency limit of the wave spectrum beyond which the wave spectrum is zeroed (rad/s)
   REAL(ReKi)                   :: PCurrVxiPz0                                     ! Partial derivative of CurrVxi        with respect to zi at zi = 0 (1/s  )
   REAL(ReKi)                   :: PCurrVyiPz0                                     ! Partial derivative of CurrVyi        with respect to zi at zi = 0 (1/s  )
   REAL(ReKi), ALLOCATABLE      :: PWaveAcc0HPz0  (:)                              ! Partial derivative of WaveAcc0H  (:) with respect to zi at zi = 0 (1/s^2)
   REAL(ReKi), ALLOCATABLE      :: PWaveAcc0VPz0  (:)                              ! Partial derivative of WaveAcc0V  (:) with respect to zi at zi = 0 (1/s^2)
   REAL(ReKi), ALLOCATABLE      :: PWaveVel0HPz0  (:)                              ! Partial derivative of WaveVel0H  (:) with respect to zi at zi = 0 (1/s  )
   REAL(ReKi), ALLOCATABLE      :: PWaveVel0HxiPz0(:)                              ! Partial derivative of WaveVel0Hxi(:) with respect to zi at zi = 0 (1/s  )
   REAL(ReKi), ALLOCATABLE      :: PWaveVel0HyiPz0(:)                              ! Partial derivative of WaveVel0Hyi(:) with respect to zi at zi = 0 (1/s  )
   REAL(ReKi), ALLOCATABLE      :: PWaveVel0VPz0  (:)                              ! Partial derivative of WaveVel0V  (:) with respect to zi at zi = 0 (1/s  )
   REAL(ReKi)                   :: S2Sd_Fact                                       ! Factor used to scale the magnitude of the WaveS2Sdd as required by the discrete time inverse Fourier transform (-)
   REAL(ReKi)                   :: Slope                                           ! Miscellanous slope used in an interpolation (-)
   REAL(ReKi), PARAMETER        :: SmllNmbr  = 9.999E-4                            ! A small number representing epsilon for taking numerical derivatives.
   REAL(ReKi)                   :: SWaveDir                                        ! SIN( WaveDir )
   REAL(ReKi), ALLOCATABLE      :: WaveAcc0H (:,:)                                 ! Instantaneous horizontal acceleration of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s^2)
   REAL(ReKi)                   :: WaveAcc0HExtrap                                 ! Temporary value extrapolated from the WaveAcc0H  (:,:) array (m/s^2)
   REAL(ReKi)                   :: WaveAcc0HInterp                                 ! Temporary value interpolated from the WaveAcc0H  (:,:) array (m/s^2)
   REAL(ReKi), ALLOCATABLE      :: WaveAcc0V (:,:)                                 ! Instantaneous vertical   acceleration of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s^2)
   REAL(ReKi)                   :: WaveAcc0VExtrap                                 ! Temporary value extrapolated from the WaveAcc0V  (:,:) array (m/s^2)
   REAL(ReKi)                   :: WaveAcc0VInterp                                 ! Temporary value interpolated from the WaveAcc0V  (:,:) array (m/s^2)
   REAL(ReKi)                   :: WaveElev_Max                                    ! Maximum expected value of the instantaneous elevation of incident waves (meters)
   REAL(ReKi)                   :: WaveElev_Min                                    ! Minimum expected value of the instantaneous elevation of incident waves (meters)
   REAL(ReKi), ALLOCATABLE      :: WaveElevxiPrime(:)                              ! Locations along the wave heading direction for points where the incident wave elevations can be output (meters)
   REAL(ReKi), ALLOCATABLE      :: WaveKinzi0Prime(:)                              ! zi-coordinates for points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed before applying stretching; these are relative to the mean see level (meters)
   REAL(ReKi), ALLOCATABLE      :: WaveKinzi0St   (:)                              ! Array of elevations found by stretching the elevations in the WaveKinzi0Prime(:) array using the instantaneous wave elevation; these are relative to the mean see level (meters)
   REAL(ReKi)                   :: WaveNmbr                                        ! Wavenumber of the current frequency component (1/meter)
   REAL(ReKi)                   :: WaveS1Sdd                                       ! One-sided power spectral density of the wave spectrum per unit time for the current frequency component (m^2/(rad/s))
   REAL(ReKi)                   :: WaveS2Sdd                                       ! Two-sided power spectral density of the wave spectrum per unit time for the current frequency component (m^2/(rad/s))
   REAL(ReKi)                   :: WaveTMax                                        ! Analysis time for incident wave calculations (sec)
   REAL(ReKi), ALLOCATABLE      :: WaveVel0H (:,:)                                 ! Instantaneous horizontal   velocity   of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s  )
   REAL(ReKi), ALLOCATABLE      :: WaveVel0Hxi    (:,:)                            ! Instantaneous xi-direction velocity   of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s  )
   REAL(ReKi)                   :: WaveVel0HxiExtrap                               ! Temporary value extrapolated from the WaveVel0Hxi(:,:) array (m/s  )
   REAL(ReKi)                   :: WaveVel0HxiInterp                               ! Temporary value interpolated from the WaveVel0Hxi(:,:) array (m/s  )
   REAL(ReKi), ALLOCATABLE      :: WaveVel0Hyi    (:,:)                            ! Instantaneous yi-direction velocity   of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s  )
   REAL(ReKi)                   :: WaveVel0HyiExtrap                               ! Temporary value extrapolated from the WaveVel0Hyi(:,:) array (m/s  )
   REAL(ReKi)                   :: WaveVel0HyiInterp                               ! Temporary value interpolated from the WaveVel0Hyi(:,:) array (m/s  )
   REAL(ReKi), ALLOCATABLE      :: WaveVel0V (:,:)                                 ! Instantaneous vertical     velocity   of incident waves before applying stretching at the zi-coordinates for points along a vertical line passing through the platform reference point (m/s  )
   REAL(ReKi)                   :: WaveVel0VExtrap                                 ! Temporary value extrapolated from the WaveVel0V  (:,:) array (m/s  )
   REAL(ReKi)                   :: WaveVel0VInterp                                 ! Temporary value interpolated from the WaveVel0V  (:,:) array (m/s  )
   REAL(ReKi)                   :: WGNC_Fact                                       ! Factor used to scale the magnitude of the WGNC      as required by the discrete time inverse Fourier transform (-)
   REAL(ReKi)                   :: zi_Max                                          ! Maximum elevation where the wave kinematics are to be applied using      stretching to the instantaneous free surface (meters)
   REAL(ReKi)                   :: zi_Min                                          ! Minimum elevation where the wave kinematics are to be applied using      stretching to the instantaneous free surface (meters)
   REAL(ReKi)                   :: ziPrime_Max                                     ! Maximum elevation where the wave kinematics are computed before applying stretching to the instantaneous free surface (meters)
   REAL(ReKi)                   :: ziPrime_Min                                     ! Minimum elevation where the wave kinematics are computed before applying stretching to the instantaneous free surface (meters)

   INTEGER(4)                   :: GHNStepWave                                     ! Total number of time steps in the GH Bladed wave data files.
   INTEGER(4)                   :: GHNWvDpth                                       ! Number of vertical locations in GH Bladed wave data files.
   INTEGER(4)                   :: I                                               ! Generic index
   INTEGER(4)                   :: I_Orig                                          ! The index of the time step from original (input) part of data
   INTEGER(4)                   :: I_WaveTp                                        ! The index of the frequency component nearest to WaveTp
   INTEGER(4)                   :: J                                               ! Generic index
   INTEGER(4)                   :: J_Min                                           ! The minimum value of index J such that WaveKinzi0(J) >= -WtrDpth
   INTEGER(4)                   :: K                                               ! Generic index
   INTEGER(4)                   :: LastInd  = 1                                    ! Index into the arrays saved from the last call as a starting point for this call
   INTEGER(4)                   :: NWaveKin0Prime                                  ! Number of points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed before applying stretching to the instantaneous free surface (-)
   INTEGER(4)                   :: Sttus                                           ! Status returned by an attempted allocation or READ.
   INTEGER(4)                   :: UnFA     = 31                                   ! I/O unit number for the file needed for the GH Bladed wave data by FAST.
   INTEGER(4)                   :: UnKi     = 32                                   ! I/O unit number for the GH Bladed wave data file containing wave particle kinematics time history.
   INTEGER(4)                   :: UnSu     = 33                                   ! I/O unit number for the GH Bladed wave data file containing surface elevation time history.

!bjj chg:   LOGICAL(1)                   :: Reading  = .TRUE.                               ! Flag to say whether or not we are still reading from the GH Bladed wave data files (files not exhausted).
   LOGICAL                      :: Reading  = .TRUE.                               ! Flag to say whether or not we are still reading from the GH Bladed wave data files (files not exhausted).
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!jmj   top of source file HydroCalc.f90 in support of improved code
!jmj   optimization:
!remove6.02c
!remove6.02c
!remove6.02c      ! Global functions:
!remove6.02c
!remove6.02c   REAL(ReKi), EXTERNAL         :: InterpStp                                       ! A generic function to do the actual interpolation.
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.




      ! Save these values for future use:

   NWaveElev  = NWaveElevIn
   NWaveKin0  = NWaveKin0In

   ALLOCATE ( DZNodes   (NWaveKin0) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the DZNodes array.')
   ENDIF

   ALLOCATE ( WaveKinzi0(NWaveKin0) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the WaveKinzi0 array.')
   ENDIF

!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   DirRoot       = DirRootIn
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   DZNodes   (:) = DZNodesIn   (:)
   Gravity       = GravityIn
   WaveDir       = WaveDirIn
   WaveKinzi0(:) = WaveKinzi0In(:)
   WaveMod       = WaveModIn
   WaveStMod     = WaveStModIn
   WaveTMax      = WaveTMaxIn
   WtrDens       = WtrDensIn
   WtrDpth       = WtrDpthIn

   RhoXg         = WtrDens*Gravity




      ! Initialize the variables associated with the incident wave:

   SELECT CASE ( WaveMod ) ! Which incident wave kinematics model are we using?

   CASE ( 0 )              ! None=still water.



      ! Initialize everything to zero:

      NStepWave  = 2                ! We must have at least two elements in order to interpolate later on
      NStepWave2 = 1

      ALLOCATE ( WaveTime      (0:NStepWave-1            ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveTime array.')
      ENDIF

      ALLOCATE ( WaveElevC0    (0:NStepWave2             ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElevC0 array.')
      ENDIF

      ALLOCATE ( WaveElev0     (0:NStepWave-1            ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElev0 array.')
      ENDIF

      ALLOCATE ( WaveElev      (0:NStepWave-1,NWaveElev  ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElev array.')
      ENDIF

      ALLOCATE ( WaveVel0      (0:NStepWave-1,NWaveKin0,3) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0 array.')
      ENDIF

      ALLOCATE ( WaveAcc0      (0:NStepWave-1,NWaveKin0,3) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAcc0 array.')
      ENDIF

      WaveDOmega = 0.0
      WaveTime   = (/ 0.0, 1.0 /)   ! We must have at least two different time steps in the interpolation
      WaveElevC0 = (0.0,0.0)
      WaveElev0  = 0.0
      WaveElev   = 0.0
      WaveVel0   = 0.0
      WaveAcc0   = 0.0


      ! Add the current velocities to the wave velocities:

      DO J = 1,NWaveKin0   ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

         CALL InitCurrent ( CurrMod      , CurrSSV0 , CurrSSDir, CurrNSRef, &
                            CurrNSV0     , CurrNSDir, CurrDIV  , CurrDIDir, &
                            WaveKinzi0(J), WtrDpth  , DirRoot  , CurrVxi  , CurrVyi )

         WaveVel0(:,J,1) = WaveVel0(:,J,1) + CurrVxi  ! xi-direction
         WaveVel0(:,J,2) = WaveVel0(:,J,2) + CurrVyi  ! yi-direction

      ENDDO                ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed




   CASE ( 1, 2, 3 )        ! Plane progressive (regular) wave, JONSWAP/Pierson-Moskowitz spectrum (irregular) wave, or user-defined spectrum (irregular) wave.



      ! Tell our nice users what is about to happen that may take a while:

!bjj start of proposed change v6.02d-bjj
!I'm marking this change, but will just change the other WriteScreen() subroutines to WrScr() from the NWTC_Library
!rm      CALL WriteScreen ( ' Generating incident wave kinematics and current time history.', '(/,A)' )
      CALL WrScr ( ' Generating incident wave kinematics and current time history.' )
!bjj end of proposed change




      ! Calculate the locations of the points along the wave heading direction
      !   where the incident wave elevations can be output:

      CWaveDir  = COS( D2R*WaveDir )
      SWaveDir  = SIN( D2R*WaveDir )

      ALLOCATE ( WaveElevxiPrime (NWaveElev) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElevxiPrime array.')
      ENDIF

      DO J = 1,NWaveElev   ! Loop through all points where the incident wave elevations can be output
         WaveElevxiPrime(J) = WaveElevxi(J)*CWaveDir + WaveElevyi(J)*SWaveDir
      ENDDO                ! J - All points where the incident wave elevations can be output




      ! Determine the number of, NWaveKin0Prime, and the zi-coordinates for,
      !   WaveKinzi0Prime(:), points along a vertical line passing through the
      !   platform reference point where the incident wave kinematics will be
      !   computed before applying stretching to the instantaneous free surface.
      !   The locations are relative to the mean see level.  Also determine J_Min,
      !   which is the minimum value of index J such that WaveKinzi0(J) >=
      !   -WtrDpth.  These depend on which incident wave kinematics stretching
      !   method is being used:

!JASON: ADD OTHER STRETCHING METHODS HERE, SUCH AS: DELTA STRETCHING (SEE ISO 19901-1) OR CHAKRABARTI STRETCHING (SEE OWTES)???
!JASON: APPLY STRETCHING TO THE DYNAMIC PRESSURE, IF YOU EVER COMPUTE THAT HERE!!!
      SELECT CASE ( WaveStMod )  ! Which model are we using to extrapolate the incident wave kinematics to the instantaneous free surface?

      CASE ( 0 )                 ! None=no stretching.


      ! Since we have no stretching, NWaveKin0Prime and WaveKinzi0Prime(:) are
      !   equal to the number of, and the zi-coordinates for, the points in the
      !   WaveKinzi0(:) array between, and including, -WtrDpth and 0.0.

      ! Determine J_Min and NWaveKin0Prime here:

         J_Min          = 0
         NWaveKin0Prime = 0
         DO J = 1,NWaveKin0   ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed
            IF (    WaveKinzi0(J) >= -WtrDpth )  THEN
               IF ( J_Min         == 0        )  J_Min = J
               IF ( WaveKinzi0(J) <= 0.0      )  THEN
                  NWaveKin0Prime = NWaveKin0Prime + 1
               ELSE
                  EXIT
               ENDIF
            ENDIF
         ENDDO                ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed



      ! ALLOCATE the WaveKinzi0Prime(:) array and compute its elements here:

         ALLOCATE ( WaveKinzi0Prime(NWaveKin0Prime) , STAT=Sttus )
         IF ( Sttus /= 0 )  THEN
            CALL ProgAbort(' Error allocating memory for the WaveKinzi0Prime array.')
         ENDIF

         DO J = 1,NWaveKin0Prime ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
            WaveKinzi0Prime(J) =      WaveKinzi0(J+J_Min-1)
         ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching



      CASE ( 1, 2 )              ! Vertical stretching or extrapolation stretching.


      ! Vertical stretching says that the wave kinematics above the mean sea level
      !   equal the wave kinematics at the mean sea level.  The wave kinematics
      !   below the mean sea level are left unchanged.
      !
      ! Extrapolation stretching uses a linear Taylor expansion of the wave
      !   kinematics (and their partial derivatives with respect to z) at the mean
      !   sea level to find the wave kinematics above the mean sea level.  The
      !   wave kinematics below the mean sea level are left unchanged.
      !
      ! Vertical stretching and extrapolation stretching do not effect the wave
      !   kinematics below the mean sea level; also, vertical stretching and
      !   extrapolation stretching say the wave kinematics above the mean sea
      !   level depend only on the mean sea level values.  Consequently,
      !   NWaveKin0Prime and WaveKinzi0Prime(:) are equal to the number of, and
      !   the zi-coordinates for, the points in the WaveKinzi0(:) array between,
      !   and including, -WtrDpth and 0.0; the WaveKinzi0Prime(:) array must also
      !   include 0.0 even if the WaveKinzi0(:) array does not.

      ! Determine J_Min and NWaveKin0Prime here:

         J_Min          = 0
         NWaveKin0Prime = 0
         DO J = 1,NWaveKin0   ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed
            IF (    WaveKinzi0(J) >= -WtrDpth )  THEN
               IF ( J_Min         == 0        )  J_Min = J
               NWaveKin0Prime = NWaveKin0Prime + 1
               IF ( WaveKinzi0(J) >= 0.0      )  EXIT
            ENDIF
         ENDDO                ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed


      ! ALLOCATE the WaveKinzi0Prime(:) array and compute its elements here:

         ALLOCATE ( WaveKinzi0Prime(NWaveKin0Prime) , STAT=Sttus )
         IF ( Sttus /= 0 )  THEN
            CALL ProgAbort(' Error allocating memory for the WaveKinzi0Prime array.')
         ENDIF

         DO J = 1,NWaveKin0Prime ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
            WaveKinzi0Prime(J) = MIN( WaveKinzi0(J+J_Min-1), 0.0 )   ! The uppermost point is always zero even if WaveKinzi0(NWaveKin0Prime+J_Min-1) > 0.0
         ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching



      CASE ( 3 )                 ! Wheeler stretching.


      ! Wheeler stretching says that wave kinematics calculated using Airy theory
      !   at the mean sea level should actually be applied at the instantaneous
      !   free surface and that Airy wave kinematics computed at locations between
      !   the seabed and the mean sea level should be shifted vertically to new
      !   locations in proportion to their elevation above the seabed.
      !
      ! Thus, given a range of zi(:) where we want to know the wave kinematics
      !   after applying Wheeler stretching, the required range of ziPrime(:)
      !   where the wave kinematics need to be computed before applying
      !   stretching, is as follows:
      !
      ! ziPrime_Min <= ziPrime(:) <= ziPrime_Max
      !
      ! ziPrime_Min = MAX{ ( zi_Min - WaveElev_Max )/( 1 + WaveElev_Max/WtrDpth ), -WtrDpth }
      ! ziPrime_Max = MIN{ ( zi_Max - WaveElev_Min )/( 1 + WaveElev_Min/WtrDpth ),        0 }
      !
      ! where,
      !   zi_Max        = maximum elevation where the wave kinematics are to be
      !                   applied using stretching to the instantaneous free
      !                   surface
      !   zi_Min        = minimum elevation where the wave kinematics are to be
      !                   applied using stretching to the instantaneous free
      !                   surface
      !   ziPrime_Max   = maximum elevation where the wave kinematics are computed
      !                   before applying stretching to the instantaneous free
      !                   surface
      !   ziPrime_Min   = minimum elevation where the wave kinematics are computed
      !                   before applying stretching to the instantaneous free
      !                   surface
      !   WaveElev_Max  = maximum expected value of the instantaneous elevation of
      !                   incident waves
      !   WaveElev_Min  = minimum expected value of the instantaneous elevation of
      !                   incident waves
      !
      ! Thus, in order to account for Wheeler stretching when computing the wave
      !   kinematics at each of the NWaveKin0 points along a vertical line passing
      !   through the platform reference point [defined by the zi-coordinates
      !   relative to the mean see level as specified in the WaveKinzi0(:) array],
      !   we must first compute the wave kinematics without stretching at
      !   alternative elevations [indicated here by the NWaveKin0Prime-element
      !   array WaveKinzi0Prime(:)]:

         IF ( NWaveKin0 > 0 )  THEN ! .TRUE. if we have at least one point along a vertical line passing through the platform reference point where the incident wave kinematics will be computed


            WaveElev_Max =  WaveHs  ! The maximum expected value the instantaneous wave elevation will most likely not exceed the value of WaveHs above the MSL since 99.99366% of all instantaneous wave elevations fall within WaveHs = 4*( the standard deviation of the incident waves ) assuming that the instanteous wave elevation is Gaussian distributed with zero mean (as implemented).
            WaveElev_Min = -WaveHs  ! The mimimum expected value the instantaneous wave elevation will most likely not exceed the value of WaveHs below the MSL since 99.99366% of all instantaneous wave elevations fall within WaveHs = 4*( the standard deviation of the incident waves ) assuming that the instanteous wave elevation is Gaussian distributed with zero mean (as implemented).

            ziPrime_Min  = MAX( WheelerStretching ( WaveKinzi0(        1), WaveElev_Max, WtrDpth, 'B' ), -WtrDpth )
            ziPrime_Max  = MIN( WheelerStretching ( WaveKinzi0(NWaveKin0), WaveElev_Min, WtrDpth, 'B' ),      0.0 )

            IF ( MIN( ziPrime_Min, 0.0) == MAX( ziPrime_Max, -WtrDpth ) )  THEN ! .TRUE. only when all of the WaveKinzi0(:) elevations are lower than the seabed or higher than the maximum wave (inclusive); thus, we will not have any points to compute wave kinematics without stretching


               NWaveKin0Prime = 0.0


            ELSE                                                                ! At least one of the WaveKinzi0(:) elevations must lie within the water


      ! Determine NWaveKin0Prime here; no reason to compute J_Min here, so don't:
      ! NOTE: See explanation of stretching above for more information.

               DO J = 1,NWaveKin0   ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

                  IF (     WheelerStretching ( WaveKinzi0(J), WaveElev_Max, WtrDpth, 'B' ) <= ziPrime_Min )  THEN

                     I              = J
                     NWaveKin0Prime = 1

                  ELSEIF ( WheelerStretching ( WaveKinzi0(J), WaveElev_Min, WtrDpth, 'B' ) >= ziPrime_Max )  THEN

                     NWaveKin0Prime = NWaveKin0Prime + 1

                     DO K = J+1,NWaveKin0 ! Loop through all remaining points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed
                        IF ( WaveKinzi0(K) >= WaveElev_Max )  THEN
                           NWaveKin0Prime = NWaveKin0Prime + 1
                           EXIT  ! EXIT this DO...LOOP
                        ELSE
                           NWaveKin0Prime = NWaveKin0Prime + 1
                        ENDIF
                     ENDDO                ! K - All remaining points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

                     EXIT  ! EXIT this DO...LOOP

                  ELSE

                     NWaveKin0Prime = NWaveKin0Prime + 1

                  ENDIF

               ENDDO                ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

               IF ( NWaveKin0Prime > 1 )  THEN ! .TRUE. if zi_Min /= zi_Max
                  zi_Min = MAX( WaveKinzi0(               I  ), -WtrDpth     )
                  zi_Max = MIN( WaveKinzi0(NWaveKin0Prime+I-1), WaveElev_Max )
                  Slope  = ( ziPrime_Max - ziPrime_Min )/( zi_Max - zi_Min )
               ELSE                            ! we must have zi_Min == Zi_Max, but we still have ziPrime_Min /= ziPrime_Max
                  NWaveKin0Prime = 2
               ENDIF


      ! ALLOCATE the WaveKinzi0Prime(:) array and compute its elements here:
      ! NOTE: See explanation of stretching above for more information.

               ALLOCATE ( WaveKinzi0Prime(NWaveKin0Prime) , STAT=Sttus )
               IF ( Sttus /= 0 )  THEN
                  CALL ProgAbort(' Error allocating memory for the WaveKinzi0Prime array.')
               ENDIF

               WaveKinzi0Prime(             1) = ziPrime_Min                                          ! First point - lowermost
               DO J = 2,NWaveKin0Prime-1  ! Loop through all but the first and last points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
                  WaveKinzi0Prime(          J) = ( WaveKinzi0(J+I-1) - zi_Min )*Slope + ziPrime_Min   ! Interpolate to find the middle points using the elevations of the WaveKinzi0(:) array
               ENDDO                      ! J - All but the first and last points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
               WaveKinzi0Prime(NWaveKin0Prime) = ziPrime_Max                                          ! Last  point - uppermost


            ENDIF


         ELSE                       ! We must not have any point along a vertical line passing through the platform reference point where the incident wave kinematics will be computed; thus, neither will we have any points to compute wave kinematics without stretching



            NWaveKin0Prime = 0


         ENDIF



      ENDSELECT




      ! Perform some initialization computations including initializing the
      !   pseudorandom number generator, calculating the total number of frequency
      !   components = total number of time steps in the incident wave,
      !   calculating the frequency step, calculating the index of the frequency
      !   component nearest to WaveTp, and ALLOCATing the arrays:
      ! NOTE: WaveDOmega = 2*Pi/WaveTMax since, in the FFT:
      !          Omega = (K-1)*WaveDOmega
      !          Time  = (J-1)*WaveDT
      !       and therefore:
      !          Omega*Time = (K-1)*(J-1)*WaveDOmega*WaveDT
      !                     = (K-1)*(J-1)*2*Pi/NStepWave [see FFT_Module]
      !       or:
      !          WaveDOmega = 2*Pi/(NStepWave*WaveDT)
      !                     = 2*Pi/WaveTMax

      CALL RANDOM_SEED ( PUT=WaveSeed(1:2) )

      NStepWave  = CEILING ( WaveTMax/WaveDT )                             ! Set NStepWave to an even integer
      IF ( MOD(NStepWave,2) == 1 )  NStepWave = NStepWave + 1              !   larger or equal to WaveTMax/WaveDT.
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Put a MAX(*,1) in the calculation of NStepWave2 and NStepRdtn2 to ensure
!jmj   that routine PSF() does not crash when WaveTMax and/or RdtnTMax are very
!jmj   small:
!remove6.02b      NStepWave2 = NStepWave/2                                             ! Make sure that NStepWave is an even product of small factors (PSF) that is
      NStepWave2 = MAX( NStepWave/2, 1 )                                   ! Make sure that NStepWave is an even product of small factors (PSF) that is
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
      NStepWave  = 2*PSF ( NStepWave2, 9 )                                 !   greater or equal to WaveTMax/WaveDT to ensure that the FFT is efficient.

      NStepWave2 = NStepWave/2                                             ! Update the value of NStepWave2 based on the value needed for NStepWave.
      WaveTMax   = NStepWave*WaveDT                                        ! Update the value of WaveTMax   based on the value needed for NStepWave.
      WaveDOmega = TwoPi/WaveTMax                                          ! Compute the frequency step for incident wave calculations.
      I_WaveTp   = NINT ( TwoPi/(WaveDOmega*WaveTp) )                      ! Compute the index of the frequency component nearest to WaveTp.
      IF ( WaveMod == 2 )  OmegaCutOff = n_Massel*TwoPi/WaveTp             ! Compute the cut-off frequency or upper frequency limit of the wave spectrum beyond which the wave spectrum is zeroed.  The TwoPi/WaveTp is the peak spectral frequency in rad/s; the cut-off frequency is a factor of N_Massel above this value based on the suggestion in: Massel, S. R., Ocean Surface Waves: Their Physics and Prediction, Advanced Series on Ocean Engineering - Vol. 11, World Scientific Publishing, Singapore - New Jersey - London - Hong Kong, 1996.

      ALLOCATE ( WaveTime      (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveTime array.')
      ENDIF

      ALLOCATE ( WaveElevC0    (0:NStepWave2                 ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElevC0 array.')
      ENDIF

      ALLOCATE ( WaveElevC     (0:NStepWave2 ,NWaveElev      ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElevC array.')
      ENDIF

      ALLOCATE ( WaveVelC0H    (0:NStepWave2 ,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVelC0H array.')
      ENDIF

      ALLOCATE ( WaveVelC0V    (0:NStepWave2 ,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVelC0V array.')
      ENDIF

      ALLOCATE ( WaveAccC0H    (0:NStepWave2 ,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAccC0H array.')
      ENDIF

      ALLOCATE ( WaveAccC0V    (0:NStepWave2 ,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAccC0V array.')
      ENDIF

      ALLOCATE ( PWaveVelC0HPz0(0:NStepWave2                 ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveVelC0HPz0 array.')
      ENDIF

      ALLOCATE ( PWaveVelC0VPz0(0:NStepWave2                 ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveVelC0VPz0 array.')
      ENDIF

      ALLOCATE ( PWaveAccC0HPz0(0:NStepWave2                 ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveAccC0HPz0 array.')
      ENDIF

      ALLOCATE ( PWaveAccC0VPz0(0:NStepWave2                 ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveAccC0VPz0 array.')
      ENDIF

      ALLOCATE ( WaveElev0     (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElev0 array.')
      ENDIF

      ALLOCATE ( WaveElev      (0:NStepWave-1,NWaveElev      ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElev array.')
      ENDIF

      ALLOCATE ( WaveVel0H     (0:NStepWave-1,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0H array.')
      ENDIF

      ALLOCATE ( WaveVel0Hxi   (0:NStepWave-1,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0Hxi array.')
      ENDIF

      ALLOCATE ( WaveVel0Hyi   (0:NStepWave-1,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0Hyi array.')
      ENDIF

      ALLOCATE ( WaveVel0V     (0:NStepWave-1,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0V array.')
      ENDIF

      ALLOCATE ( WaveAcc0H     (0:NStepWave-1,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAcc0H array.')
      ENDIF

      ALLOCATE ( WaveAcc0V     (0:NStepWave-1,NWaveKin0Prime ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAcc0V array.')
      ENDIF

      ALLOCATE ( PWaveVel0HPz0 (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveVel0HPz0 array.')
      ENDIF

      ALLOCATE ( PWaveVel0HxiPz0 (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveVel0HxiPz0 array.')
      ENDIF

      ALLOCATE ( PWaveVel0HyiPz0 (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveVel0HyiPz0 array.')
      ENDIF

      ALLOCATE ( PWaveVel0VPz0 (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveVel0VPz0 array.')
      ENDIF

      ALLOCATE ( PWaveAcc0HPz0 (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveAcc0HPz0 array.')
      ENDIF

      ALLOCATE ( PWaveAcc0VPz0 (0:NStepWave-1                ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the PWaveAcc0VPz0 array.')
      ENDIF

      ALLOCATE ( WaveVel0      (0:NStepWave-1,NWaveKin0,3    ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0 array.')
      ENDIF

      ALLOCATE ( WaveAcc0      (0:NStepWave-1,NWaveKin0,3    ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAcc0 array.')
      ENDIF



      ! Calculate the factors needed by the discrete time inverse Fourier
      !   transform in the calculations of the White Gaussian Noise (WGN) and
      !   the two-sided power spectral density of the wave spectrum per unit time:

      WGNC_Fact = SQRT( Pi/(WaveDOmega*WaveDT) )   ! This factor is needed by the discrete time inverse Fourier transform to ensure that the time series WGN process has unit variance
      S2Sd_Fact = 1.0/WaveDT                       ! This factor is also needed by the discrete time inverse Fourier transform



      ! Compute the positive-frequency components (including zero) of the Fourier
      !  transforms of the wave kinematics:

      DO I = 0,NStepWave2  ! Loop through the positive frequency components (including zero) of the Fourier transforms


      ! Compute the frequency of this component and its imaginary value:

             Omega = I*  WaveDOmega
         ImagOmega = ImagNmbr*Omega


      ! Compute the Fourier transform of the realization of a White Gaussian Noise
      !   (WGN) time series process with unit variance:
      ! NOTE: For the time series process to be real with zero mean, the values at
      !       Omega == 0.0 and Omega == NStepWave2*WaveDOmega (= WaveOmegaMax)
      !       must be zero.

         IF ( ( I == 0 ) .OR. ( I == NStepWave2 ) )  THEN   ! .TRUE. if ( Omega == 0.0 ) or ( Omega == NStepWave2*WaveDOmega (= WaveOmegaMax) )
            WGNC = (0.0,0.0)
         ELSE                                               ! All other Omega
            WGNC = BoxMuller ( )
            IF ( ( WaveMod == 1 ) .AND. ( I == I_WaveTp ) )  WGNC = WGNC*( SQRT(2.0)/ABS(WGNC) )   ! This scaling of WGNC is used to ensure that the Box-Muller method is only providing a random phase, not a magnitude change, at the frequency of the plane progressive wave.  The SQRT(2.0) is used to ensure that the time series WGN process has unit variance (i.e. sinusoidal with amplitude SQRT(2.0)).  NOTE: the denominator here will never equal zero since U1 cannot equal 1.0, and thus, C1 cannot be 0.0 in the Box-Muller method.
         ENDIF


      ! Compute the one-sided power spectral density of the wave spectrum per unit
      !   time; zero-out the wave spectrum above the cut-off frequency:

         SELECT CASE ( WaveMod ) ! Which incident wave kinematics model are we using?

         CASE ( 1 )              ! Plane progressive (regular) wave; the wave spectrum is an impulse function centered on frequency component closest to WaveTp.
            IF ( I == I_WaveTp )  THEN       ! .TRUE. if we are at the Omega closest to WaveTp.
               WaveS1Sdd = 0.5*(WaveHs/2.0)*(WaveHs/2.0)/WaveDOmega
            ELSE                             ! All other Omega
               WaveS1Sdd = 0.0
            ENDIF

         CASE ( 2 )              ! JONSWAP/Pierson-Moskowitz spectrum (irregular) wave.
            IF ( Omega > OmegaCutOff )  THEN ! .TRUE. if Omega is above the cut-off frequency
               WaveS1Sdd = 0.0  ! Zero-out the wave spectrum above the cut-off frequency.  We must cut-off the frequency in order to avoid nonphysical wave forces.  Waves that have wavelengths much smaller than the platform diameter (high frequency) do not contribute to the net force because regions of positive and negative velocity/acceleration are experienced by the platform at the same time and cancel out.  !JASON: OTHER FREQUENCY CUT-OFF CONDITIONS ARE USED THROUGHOUT THE INDUSTRY.  SHOULD YOU USE ONE OF THEM INSTEAD?  SEE, FOR EXAMPLE, MY E-MAIL EXCHANGES WITH PAUL SCLAVOUNOS DATED 5/26/2006 OR: "GH Bladed Thoery Manual" OR: Trumars, Jenny M. V.; Tarp-Johansen, Niels Jacob; Krogh, Thomas; "The Effect of Wave Modelling on Offshore Wind Turbine Fatigue Loads," 2005 Copenhagen Offshore Wind Conference and Exhibition, 26-28 October 2005, Copenhagen, Denmark [CD-ROM].
            ELSE                             ! All other Omega
               WaveS1Sdd = JONSWAP ( Omega, WaveHs, WaveTp, WavePkShp )
            ENDIF

         CASE ( 3 )              ! User-defined spectrum (irregular) wave.
            CALL UserWaveSpctrm ( Omega, WaveDir, DirRoot, WaveS1Sdd )

         ENDSELECT



      ! Compute the two-sided power spectral density of the wave spectrum per unit
      !   time:

         WaveS2Sdd  = 0.5*WaveS1Sdd


      ! Compute the wavenumber:

         WaveNmbr   = WaveNumber ( Omega, Gravity, WtrDpth )


      ! Compute the Fourier transform of the instantaneous elevation of incident
      !   waves at the platform reference point:

         WaveElevC0    (I  ) = ( WGNC_Fact*WGNC )*SQRT( TwoPi*( S2Sd_Fact*WaveS2Sdd ) )


      ! Compute the Fourier transform of the instantaneous elevation of incident
      !   waves at each desired point on the still water level plane where it can
      !   be output:

         DO J = 1,NWaveElev   ! Loop through all points where the incident wave elevations can be output
            WaveElevC  (I,J) =            WaveElevC0   (I  )*EXP( -ImagNmbr*WaveNmbr*WaveElevxiPrime(J) )
         ENDDO                ! J - All points where the incident wave elevations can be output


      ! Compute the Fourier transform of the incident wave kinematics before
      !   applying stretching at the zi-coordinates for points along a vertical
      !   line passing through the platform reference point:

         DO J = 1,NWaveKin0Prime ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching

            WaveVelC0H (I,J) =     Omega* WaveElevC0   (I  )*COSHNumOvrSIHNDen ( WaveNmbr, WtrDpth, WaveKinzi0Prime(J) )
            WaveVelC0V (I,J) = ImagOmega* WaveElevC0   (I  )*SINHNumOvrSIHNDen ( WaveNmbr, WtrDpth, WaveKinzi0Prime(J) )
            WaveAccC0H (I,J) = ImagOmega* WaveVelC0H   (I,J)
            WaveAccC0V (I,J) = ImagOmega* WaveVelC0V   (I,J)

         ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching

         PWaveVelC0HPz0(I  ) =     Omega* WaveElevC0   (I  )*WaveNmbr
         PWaveVelC0VPz0(I  ) = ImagOmega* WaveElevC0   (I  )*WaveNmbr*COTH ( WaveNmbr*WtrDpth )
         PWaveAccC0HPz0(I  ) = ImagOmega*PWaveVelC0HPz0(I  )
         PWaveAccC0VPz0(I  ) = ImagOmega*PWaveVelC0VPz0(I  )


      ENDDO                ! I - The positive frequency components (including zero) of the Fourier transforms




      ! Calculate the array of simulation times at which the instantaneous
      !   elevation of, velocity of, acceleration of, and loads associated with
      !   the incident waves are to be determined:

      DO I = 0,NStepWave-1 ! Loop through all time steps
         WaveTime(I) = I*WaveDT
      ENDDO                ! I - All time steps


      ! Compute the inverse Fourier transforms to find the time-domain
      !   representations of the wave kinematics without stretcing:

      CALL InitFFT ( NStepWave, .TRUE. )

      CALL    ApplyFFT_cx (  WaveElev0   (:  ),  WaveElevC0   (:  ) )
      DO J = 1,NWaveElev      ! Loop through all points where the incident wave elevations can be output
         CALL ApplyFFT_cx (  WaveElev    (:,J),  WaveElevC    (:,J) )
      ENDDO                   ! J - All points where the incident wave elevations can be output
      DO J = 1,NWaveKin0Prime ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
         CALL ApplyFFT_cx (  WaveVel0H   (:,J),  WaveVelC0H   (:,J) )
         CALL ApplyFFT_cx (  WaveVel0V   (:,J),  WaveVelC0V   (:,J) )
         CALL ApplyFFT_cx (  WaveAcc0H   (:,J),  WaveAccC0H   (:,J) )
         CALL ApplyFFT_cx (  WaveAcc0V   (:,J),  WaveAccC0V   (:,J) )
      ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
      CALL    ApplyFFT_cx ( PWaveVel0HPz0(:  ), PWaveVelC0HPz0(:  ) )
      CALL    ApplyFFT_cx ( PWaveVel0VPz0(:  ), PWaveVelC0VPz0(:  ) )
      CALL    ApplyFFT_cx ( PWaveAcc0HPz0(:  ), PWaveAccC0HPz0(:  ) )
      CALL    ApplyFFT_cx ( PWaveAcc0VPz0(:  ), PWaveAccC0VPz0(:  ) )

      CALL ExitFFT




      ! Add the current velocities to the wave velocities:
      ! NOTE: Both the horizontal velocities and the partial derivative of the
      !       horizontal velocities with respect to zi at zi = 0 are found here.

      DO J = 1,NWaveKin0Prime ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching

         CALL InitCurrent (  CurrMod           , CurrSSV0 , CurrSSDir, CurrNSRef, &
                             CurrNSV0          , CurrNSDir, CurrDIV  , CurrDIDir, &
                             WaveKinzi0Prime(J), WtrDpth  , DirRoot  , CurrVxi  , CurrVyi  )

         WaveVel0Hxi (:,J) =  WaveVel0H   (:,J)*CWaveDir +  CurrVxi     ! xi-direction
         WaveVel0Hyi (:,J) =  WaveVel0H   (:,J)*SWaveDir +  CurrVyi     ! yi-direction

      ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching

      CALL    InitCurrent (  CurrMod          , CurrSSV0 , CurrSSDir, CurrNSRef, &
                             CurrNSV0         , CurrNSDir, CurrDIV  , CurrDIDir, &
                             0.0              , WtrDpth  , DirRoot  , CurrVxi0 , CurrVyi0 )
      CALL    InitCurrent (  CurrMod          , CurrSSV0 , CurrSSDir, CurrNSRef, &
                             CurrNSV0         , CurrNSDir, CurrDIV  , CurrDIDir, &
                            -SmllNmbr         , WtrDpth  , DirRoot  , CurrVxiS , CurrVyiS )

      PCurrVxiPz0 = ( CurrVxi0 - CurrVxiS )/SmllNmbr                    ! xi-direction
      PCurrVyiPz0 = ( CurrVyi0 - CurrVyiS )/SmllNmbr                    ! yi-direction

      PWaveVel0HxiPz0(:  ) = PWaveVel0HPz0(:  )*CWaveDir + PCurrVxiPz0  ! xi-direction
      PWaveVel0HyiPz0(:  ) = PWaveVel0HPz0(:  )*SWaveDir + PCurrVyiPz0  ! yi-direction




      ! Apply stretching to obtain the wave kinematics, WaveVel0 and WaveAcc0, at
      !   the desired locations from the wave kinematics at alternative locations,
      !   WaveVel0Hxi, WaveVel0Hyi, WaveVel0V, WaveAcc0H, WaveAcc0V, if the elevation
      !   of the point defined by  WaveKinzi0(J) lies between the seabed and the
      !   instantaneous free surface, else set WaveVel0 and WaveAcc0 to zero.
      !   This depends on which incident wave kinematics stretching method is
      !   being used:

      SELECT CASE ( WaveStMod )  ! Which model are we using to extrapolate the incident wave kinematics to the instantaneous free surface?

      CASE ( 0 )                 ! None=no stretching.


      ! Since we have no stretching, the wave kinematics between the seabed and
      !   the mean sea level are left unchanged; below the seabed or above the
      !   mean sea level, the wave kinematics are zero:

         DO I = 0,NStepWave-1       ! Loop through all time steps

            DO J = 1,NWaveKin0      ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

               IF (   ( WaveKinzi0(J) < -WtrDpth ) .OR. ( WaveKinzi0(J) > 0.0          ) )  THEN   ! .TRUE. if the elevation of the point defined by WaveKinzi0(J) lies below the seabed or above mean sea level (exclusive)

                  WaveVel0(I,J,:)   = 0.0
                  WaveAcc0(I,J,:)   = 0.0

               ELSE                                                                                 ! The elevation of the point defined by WaveKinzi0(J) must lie between the seabed and the mean sea level (inclusive)

                  WaveVel0(I,J,1)   = WaveVel0Hxi(I,J-J_Min+1     )
                  WaveVel0(I,J,2)   = WaveVel0Hyi(I,J-J_Min+1     )
                  WaveVel0(I,J,3)   = WaveVel0V  (I,J-J_Min+1     )
                  WaveAcc0(I,J,1)   = WaveAcc0H  (I,J-J_Min+1     )*CWaveDir
                  WaveAcc0(I,J,2)   = WaveAcc0H  (I,J-J_Min+1     )*SWaveDir
                  WaveAcc0(I,J,3)   = WaveAcc0V  (I,J-J_Min+1     )

               ENDIF

            ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

         ENDDO                      ! I - All time steps



      CASE ( 1 )                 ! Vertical stretching.


      ! Vertical stretching says that the wave kinematics above the mean sea level
      !   equal the wave kinematics at the mean sea level.  The wave kinematics
      !   below the mean sea level are left unchanged:

         DO I = 0,NStepWave-1       ! Loop through all time steps

            DO J = 1,NWaveKin0      ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

               IF (   ( WaveKinzi0(J) < -WtrDpth ) .OR. ( WaveKinzi0(J) > WaveElev0(I) ) )  THEN   ! .TRUE. if the elevation of the point defined by WaveKinzi0(J) lies below the seabed or above the instantaneous free surface (exclusive)

                  WaveVel0(I,J,:)   = 0.0
                  WaveAcc0(I,J,:)   = 0.0

               ELSEIF ( WaveKinzi0(J) > 0.0                                              )  THEN   ! .TRUE. if the elevation of the point devined by WaveKinzi0(J) lies between the mean sea level (exclusive) and the instantaneous free surface (inclusive)

                  WaveVel0(I,J,1)   = WaveVel0Hxi(I,NWaveKin0Prime)
                  WaveVel0(I,J,2)   = WaveVel0Hyi(I,NWaveKin0Prime)
                  WaveVel0(I,J,3)   = WaveVel0V  (I,NWaveKin0Prime)
                  WaveAcc0(I,J,1)   = WaveAcc0H  (I,NWaveKin0Prime)*CWaveDir
                  WaveAcc0(I,J,2)   = WaveAcc0H  (I,NWaveKin0Prime)*SWaveDir
                  WaveAcc0(I,J,3)   = WaveAcc0V  (I,NWaveKin0Prime)

               ELSE                                                                                ! The elevation of the point defined by WaveKinzi0(J) must lie between the seabed and the mean sea level (inclusive)

                  WaveVel0(I,J,1)   = WaveVel0Hxi(I,J-J_Min+1     )
                  WaveVel0(I,J,2)   = WaveVel0Hyi(I,J-J_Min+1     )
                  WaveVel0(I,J,3)   = WaveVel0V  (I,J-J_Min+1     )
                  WaveAcc0(I,J,1)   = WaveAcc0H  (I,J-J_Min+1     )*CWaveDir
                  WaveAcc0(I,J,2)   = WaveAcc0H  (I,J-J_Min+1     )*SWaveDir
                  WaveAcc0(I,J,3)   = WaveAcc0V  (I,J-J_Min+1     )

               ENDIF

            ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

         ENDDO                      ! I - All time steps



      CASE ( 2 )                 ! Extrapolation stretching.


      ! Extrapolation stretching uses a linear Taylor expansion of the wave
      !   kinematics (and their partial derivatives with respect to z) at the mean
      !   sea level to find the wave kinematics above the mean sea level.  The
      !   wave kinematics below the mean sea level are left unchanged:

         DO I = 0,NStepWave-1       ! Loop through all time steps

            DO J = 1,NWaveKin0      ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

               IF (   ( WaveKinzi0(J) < -WtrDpth ) .OR. ( WaveKinzi0(J) > WaveElev0(I) ) )  THEN   ! .TRUE. if the elevation of the point defined by WaveKinzi0(J) lies below the seabed or above the instantaneous free surface (exclusive)

                  WaveVel0(I,J,:)   = 0.0
                  WaveAcc0(I,J,:)   = 0.0

               ELSEIF ( WaveKinzi0(J) > 0.0                                              )  THEN   ! .TRUE. if the elevation of the point devined by WaveKinzi0(J) lies between the mean sea level (exclusive) and the instantaneous free surface (inclusive)

                  WaveVel0HxiExtrap = WaveVel0Hxi(I,NWaveKin0Prime) + WaveKinzi0(J)*PWaveVel0HxiPz0(I)   ! This is the extrapolation using a linear Taylor expansion
                  WaveVel0HyiExtrap = WaveVel0Hyi(I,NWaveKin0Prime) + WaveKinzi0(J)*PWaveVel0HyiPz0(I)   ! This is the extrapolation using a linear Taylor expansion
                  WaveVel0VExtrap   = WaveVel0V  (I,NWaveKin0Prime) + WaveKinzi0(J)*PWaveVel0VPz0  (I)   ! "
                  WaveAcc0HExtrap   = WaveAcc0H  (I,NWaveKin0Prime) + WaveKinzi0(J)*PWaveAcc0HPz0  (I)   ! "
                  WaveAcc0VExtrap   = WaveAcc0V  (I,NWaveKin0Prime) + WaveKinzi0(J)*PWaveAcc0VPz0  (I)   ! "

                  WaveVel0(I,J,1)   = WaveVel0HxiExtrap
                  WaveVel0(I,J,2)   = WaveVel0HyiExtrap
                  WaveVel0(I,J,3)   = WaveVel0VExtrap
                  WaveAcc0(I,J,1)   = WaveAcc0HExtrap              *CWaveDir
                  WaveAcc0(I,J,2)   = WaveAcc0HExtrap              *SWaveDir
                  WaveAcc0(I,J,3)   = WaveAcc0VExtrap

               ELSE                                                                                ! The elevation of the point defined by WaveKinzi0(J) must lie between the seabed and the mean sea level (inclusive)

                  WaveVel0(I,J,1)   = WaveVel0Hxi(I,J-J_Min+1     )
                  WaveVel0(I,J,2)   = WaveVel0Hyi(I,J-J_Min+1     )
                  WaveVel0(I,J,3)   = WaveVel0V  (I,J-J_Min+1     )
                  WaveAcc0(I,J,1)   = WaveAcc0H  (I,J-J_Min+1     )*CWaveDir
                  WaveAcc0(I,J,2)   = WaveAcc0H  (I,J-J_Min+1     )*SWaveDir
                  WaveAcc0(I,J,3)   = WaveAcc0V  (I,J-J_Min+1     )

               ENDIF

            ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

         ENDDO                      ! I - All time steps



      CASE ( 3 )                 ! Wheeler stretching.


      ! Wheeler stretching says that wave kinematics calculated using Airy theory
      !   at the mean sea level should actually be applied at the instantaneous
      !   free surface and that Airy wave kinematics computed at locations between
      !   the seabed and the mean sea level should be shifted vertically to new
      !   locations in proportion to their elevation above the seabed.
      !
      ! Computing the wave kinematics with Wheeler stretching requires that first
      !   say that the wave kinematics we computed at the elevations defined by
      !   the WaveKinzi0Prime(:) array are actual applied at the elevations found
      !   by stretching the elevations in the WaveKinzi0Prime(:) array using the
      !   instantaneous wave elevation--these new elevations are stored in the
      !   WaveKinzi0St(:) array.  Next, we interpolate the wave kinematics
      !   computed without stretching to the desired elevations (defined in the
      !   WaveKinzi0(:) array) using the WaveKinzi0St(:) array:

         ALLOCATE ( WaveKinzi0St(NWaveKin0Prime) , STAT=Sttus )
         IF ( Sttus /= 0 )  THEN
            CALL ProgAbort(' Error allocating memory for the WaveKinzi0St array.')
         ENDIF

         DO I = 0,NStepWave-1       ! Loop through all time steps

            DO J = 1,NWaveKin0Prime ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching
               WaveKinzi0St(J) = WheelerStretching ( WaveKinzi0Prime(J), WaveElev0(I), WtrDpth, 'F' )
            ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed without stretching

            DO J = 1,NWaveKin0      ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

               IF (   ( WaveKinzi0(J) < -WtrDpth ) .OR. ( WaveKinzi0(J) > WaveElev0(I) ) )  THEN   ! .TRUE. if the elevation of the point defined by WaveKinzi0(J) lies below the seabed or above the instantaneous free surface (exclusive)

                  WaveVel0(I,J,:)   = 0.0
                  WaveAcc0(I,J,:)   = 0.0

               ELSE                                                                                ! The elevation of the point defined by WaveKinzi0(J) must lie between the seabed and the instantaneous free surface (inclusive)

                  WaveVel0HxiInterp = InterpStp ( WaveKinzi0(J), WaveKinzi0St(:), WaveVel0Hxi(I,:), LastInd, NWaveKin0Prime )
                  WaveVel0HyiInterp = InterpStp ( WaveKinzi0(J), WaveKinzi0St(:), WaveVel0Hyi(I,:), LastInd, NWaveKin0Prime )
                  WaveVel0VInterp   = InterpStp ( WaveKinzi0(J), WaveKinzi0St(:), WaveVel0V  (I,:), LastInd, NWaveKin0Prime )
                  WaveAcc0HInterp   = InterpStp ( WaveKinzi0(J), WaveKinzi0St(:), WaveAcc0H  (I,:), LastInd, NWaveKin0Prime )
                  WaveAcc0VInterp   = InterpStp ( WaveKinzi0(J), WaveKinzi0St(:), WaveAcc0V  (I,:), LastInd, NWaveKin0Prime )

                  WaveVel0(I,J,1)   = WaveVel0HxiInterp
                  WaveVel0(I,J,2)   = WaveVel0HyiInterp
                  WaveVel0(I,J,3)   = WaveVel0VInterp
                  WaveAcc0(I,J,1)   = WaveAcc0HInterp              *CWaveDir
                  WaveAcc0(I,J,2)   = WaveAcc0HInterp              *SWaveDir
                  WaveAcc0(I,J,3)   = WaveAcc0VInterp

               ENDIF

            ENDDO                   ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

         ENDDO                      ! I - All time steps



      ENDSELECT




   CASE ( 4 )              ! GH Bladed wave data.



      ! Tell our nice users what is about to happen that may take a while:

      CALL WrScr1 ( ' Reading in wave data from GH Bladed files with root name "'//TRIM(GHWvFile)//'".' )



      ! Perform some initialization computations including calculating the
      !   total number of time steps in the incident wave and ALLOCATing the
      !   arrays; initialize the unneeded values to zero:

      NStepWave  = CEILING ( WaveTMax/WaveDT )                             ! Set NStepWave to an even integer
      IF ( MOD(NStepWave,2) == 1 )  NStepWave = NStepWave + 1              !   larger or equal to WaveTMax/WaveDT.
      NStepWave2 = NStepWave/2

      ALLOCATE ( WaveTime      (0:NStepWave-1            ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveTime array.')
      ENDIF

      ALLOCATE ( WaveElevC0    (0:NStepWave2             ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElevC0 array.')
      ENDIF

      ALLOCATE ( WaveElev0     (0:NStepWave-1            ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElev0 array.')
      ENDIF

      ALLOCATE ( WaveElev      (0:NStepWave-1,NWaveElev  ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveElev array.')
      ENDIF

      ALLOCATE ( WaveVel0      (0:NStepWave-1,NWaveKin0,3) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveVel0 array.')
      ENDIF

      ALLOCATE ( WaveAcc0      (0:NStepWave-1,NWaveKin0,3) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveAcc0 array.')
      ENDIF

      WaveDOmega = 0.0
      WaveElevC0 = (0.0,0.0)



      ! Open the file needed for the GH Bladed wave data by FAST, read in the
      !   input parameters, then close it again:

      CALL OpenFInpFile ( UnFA, TRIM(GHWvFile)//'_FAST.txt' ) ! Open file.


      ! GHNWvDpth - Number of vertical locations in GH Bladed wave data files.

      READ (UnFA,*)  GHNWvDpth

      IF ( GHNWvDpth <= 0 )  CALL ProgAbort ( ' GHNWvDpth must be greater than zero.' )


      ! GHWvDpth - Vertical locations in GH Bladed wave data files.

      ALLOCATE ( GHWvDpth(GHNWvDpth) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the GHWvDpth array.')
      ENDIF

      DO J = 1,GHNWvDpth   ! Loop through all vertical locations in the GH Bladed wave data files
         READ (unFA,*)  GHWvDpth(J)
      ENDDO                ! J - All vertical locations in the GH Bladed wave data files

      IF ( GHWvDpth(1) /= -WtrDpth )  CALL ProgAbort ( ' GHWvDpth(1) must be set to -WtrDpth when WaveMod is set to 4.' )


      CLOSE ( UnFA )                                        ! Close file.



      ! ALLOCATE arrays associated with the GH Bladed wave data:

      ALLOCATE ( GHWaveVel(GHNWvDpth,3) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the GHWaveVel array.')
      ENDIF

      ALLOCATE ( GHWaveAcc(GHNWvDpth,3) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the GHWaveAcc array.')
      ENDIF



      ! Open the GH Bladed wave data files:

      CALL OpenFInpFile ( UnKi, TRIM(GHWvFile)//'_kinematics.txt' )
      CALL OpenFInpFile ( UnSu, TRIM(GHWvFile)//'_surface.txt' )



      ! Skip first line in the surface file:

      READ (UnSu,'()')


      ! Process data for all the time steps:

      DO I = 0,NStepWave-1 ! Loop through all time steps


      ! Calculate the array of simulation times at which the instantaneous
      !   elevation of, velocity of, acceleration of, and loads associated with
      !   the incident waves are to be determined:

         WaveTime(I) = I*WaveDT


         IF ( Reading )  THEN       ! .TRUE. if we are still reading from the GH Bladed wave data files.


      ! Let's read in data for this time step:

            READ (UnSu,*,IOSTAT=Sttus)  GHWaveTime, WaveElev0(I)

            IF ( Sttus == 0 )  THEN ! .TRUE. if there was no error reading in the line of data

               IF ( NINT( GHWaveTime/WaveDT ) /= I )  &  ! This is the same as: IF ( GHWaveTime /= WaveTime(I) ), but works better numerically
                  CALL ProgAbort ( ' The input value of WaveDT is not consistent with the'// &
                               ' time step inherent in the GH Bladed wave data files.'     )

               DO J = 1,GHNWvDpth   ! Loop through all vertical locations in the GH Bladed wave data files
                  READ (UnKi,*)  ( GHWaveVel(J,K), K=1,3 ), ( GHWaveAcc(J,K), K=1,3 ), GHQBar
               ENDDO                ! J - All vertical locations in the GH Bladed wave data files


      ! Let's interpolate GHWaveVel and GHWaveAcc to find WaveVel0 and WaveAcc0 if
      !   the elevation of the point defined by WaveKinzi0(J) lies within the
      !   range of GHWvDpth, else set WaveVel0 and WaveAcc0 to zero:

               DO J = 1,NWaveKin0   ! Loop through all points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed
                  IF ( ( WaveKinzi0(J) < GHWvDpth(1) ) .OR. ( WaveKinzi0(J) > GHWvDpth(GHNWvDpth) ) )  THEN ! .TRUE. if the elevation of the point defined by WaveKinzi0(J) lies outside the range of GHWvDpth
                     WaveVel0    (I,J,:) = 0.0
                     WaveAcc0    (I,J,:) = 0.0
                  ELSE                                                                                      ! The elevation of the point defined by WaveKinzi0(J) must lie within the range of GHWvDpth; therefore, interpolate to find the incident wave kinematics at that elevation
                     DO K = 1,3     ! Loop through all xi- (1), yi- (2), and zi- (3) directions
                        WaveVel0 (I,J,K) = InterpStp ( WaveKinzi0(J), GHWvDpth(:), GHWaveVel(:,K), LastInd, GHNWvDpth )
                        WaveAcc0 (I,J,K) = InterpStp ( WaveKinzi0(J), GHWvDpth(:), GHWaveAcc(:,K), LastInd, GHNWvDpth )
                     ENDDO          ! K - All xi- (1), yi- (2), and zi- (3) directions
                  ENDIF
               ENDDO                ! J - All points along a vertical line passing through the platform reference point where the incident wave kinematics will be computed

            ELSE                    ! There must have been an error reading in the line of data

               GHNStepWave = I
               Reading     = .FALSE.

            END IF


         ENDIF


         IF ( .NOT. Reading )  THEN ! .TRUE. if we have finished reading from the GH Bladed wave data files.


      ! Let's reuse the input data to fill out the array:

            I_Orig = MOD( I, GHNStepWave )

            WaveElev0(I    ) = WaveElev0(I_Orig    )
            WaveVel0 (I,:,:) = WaveVel0 (I_Orig,:,:)
            WaveAcc0 (I,:,:) = WaveAcc0 (I_Orig,:,:)


         ENDIF


      ENDDO                ! I - All time steps


      ! Close the GH Bladed wave data files:

      CLOSE ( UnKi )
      CLOSE ( UnSu )



      ! Compute the incident wave elevations at each desired point on the still
      !   water level plane where it can be output; the only available point in
      !   the GH Bladed wave data is (xi=0.0,yi=0.0):

      DO J = 1,NWaveElev   ! Loop through all points where the incident wave elevations can be output
         WaveElev (:,J) = WaveElev0(:)
      ENDDO                ! J - All points where the incident wave elevations can be output




   ENDSELECT

!BJJ START of proposed change

      ! deallocate arrays
      
   IF ( ALLOCATED( PWaveAccC0HPz0  ) )  DEALLOCATE ( PWaveAccC0HPz0  )
   IF ( ALLOCATED( PWaveAccC0VPz0  ) )  DEALLOCATE ( PWaveAccC0VPz0  )
   IF ( ALLOCATED( PWaveVelC0HPz0  ) )  DEALLOCATE ( PWaveVelC0HPz0  )
   IF ( ALLOCATED( PWaveVelC0VPz0  ) )  DEALLOCATE ( PWaveVelC0VPz0  )
   IF ( ALLOCATED( WaveAccC0H      ) )  DEALLOCATE ( WaveAccC0H      )
   IF ( ALLOCATED( WaveAccC0V      ) )  DEALLOCATE ( WaveAccC0V      )
   IF ( ALLOCATED( WaveElevC       ) )  DEALLOCATE ( WaveElevC       )
   IF ( ALLOCATED( WaveVelC0H      ) )  DEALLOCATE ( WaveVelC0H      )
   IF ( ALLOCATED( WaveVelC0V      ) )  DEALLOCATE ( WaveVelC0V      )
   IF ( ALLOCATED( GHWaveAcc       ) )  DEALLOCATE ( GHWaveAcc       )
   IF ( ALLOCATED( GHWaveVel       ) )  DEALLOCATE ( GHWaveVel       )
   IF ( ALLOCATED( GHWvDpth        ) )  DEALLOCATE ( GHWvDpth        )
   IF ( ALLOCATED( PWaveAcc0HPz0   ) )  DEALLOCATE ( PWaveAcc0HPz0   )
   IF ( ALLOCATED( PWaveAcc0VPz0   ) )  DEALLOCATE ( PWaveAcc0VPz0   )
   IF ( ALLOCATED( PWaveVel0HPz0   ) )  DEALLOCATE ( PWaveVel0HPz0   )
   IF ( ALLOCATED( PWaveVel0HxiPz0 ) )  DEALLOCATE ( PWaveVel0HxiPz0 )
   IF ( ALLOCATED( PWaveVel0HyiPz0 ) )  DEALLOCATE ( PWaveVel0HyiPz0 )
   IF ( ALLOCATED( PWaveVel0VPz0   ) )  DEALLOCATE ( PWaveVel0VPz0   )
   IF ( ALLOCATED( WaveAcc0H       ) )  DEALLOCATE ( WaveAcc0H       )
   IF ( ALLOCATED( WaveAcc0V       ) )  DEALLOCATE ( WaveAcc0V       )
   IF ( ALLOCATED( WaveElevxiPrime ) )  DEALLOCATE ( WaveElevxiPrime )
   IF ( ALLOCATED( WaveKinzi0Prime ) )  DEALLOCATE ( WaveKinzi0Prime )
   IF ( ALLOCATED( WaveKinzi0St    ) )  DEALLOCATE ( WaveKinzi0St    )
   IF ( ALLOCATED( WaveVel0H       ) )  DEALLOCATE ( WaveVel0H       )
   IF ( ALLOCATED( WaveVel0Hxi     ) )  DEALLOCATE ( WaveVel0Hxi     )
   IF ( ALLOCATED( WaveVel0Hyi     ) )  DEALLOCATE ( WaveVel0Hyi     )
   IF ( ALLOCATED( WaveVel0V       ) )  DEALLOCATE ( WaveVel0V       )
!bjj end of proposed change


   RETURN
   CONTAINS
!=======================================================================
!bjj start of proposed change
!rm      FUNCTION BoxMuller
      FUNCTION BoxMuller( )
!bjj end of proposed change


         ! This FUNCTION uses the Box-Muller method to turn two uniformly
         ! distributed randoms into two unit normal randoms, which are
         ! returned as real and imaginary components.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      COMPLEX(ReKi)                :: BoxMuller                                       ! This function


         ! Local Variables:

      REAL(ReKi)                   :: C1                                              ! Intermediate variable
      REAL(ReKi)                   :: C2                                              ! Intermediate variable
      REAL(ReKi)                   :: U1                                              ! First  uniformly distributed random
      REAL(ReKi)                   :: U2                                              ! Second uniformly distributed random



         ! Compute the two uniformly distributed randoms:
         ! NOTE: The first random, U1, cannot be zero else the LOG() function
         !       below will blow up; there is no restriction on the value of the
         !       second random, U2.

      U1 = 0.0
      DO WHILE ( U1 == 0.0 )
         CALL RANDOM_NUMBER(U1)
      ENDDO
      CALL    RANDOM_NUMBER(U2)


         ! Compute intermediate variables:

      C1 = SQRT( -2.0*LOG(U1) )
      C2 = TwoPi*U2


         ! Compute the unit normal randoms:

      BoxMuller = CMPLX( C1*COS(C2), C1*SIN(C2) )



      RETURN
      END FUNCTION BoxMuller
!=======================================================================
      FUNCTION COSHNumOvrSIHNDen ( k, h, z )


         ! This FUNCTION computes the shallow water hyperbolic numerator
         ! over denominator term in the wave kinematics expressions:
         !
         !                    COSH( k*( z + h ) )/SINH( k*h )
         !
         ! given the wave number, k, water depth, h, and elevation z, as
         ! inputs.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi)                   :: COSHNumOvrSIHNDen                               ! This function = COSH( k*( z + h ) )/SINH( k*h ) (-)
      REAL(ReKi), INTENT(IN )      :: h                                               ! Water depth ( h      >  0 ) (meters)
      REAL(ReKi), INTENT(IN )      :: k                                               ! Wave number ( k      >= 0 ) (1/m)
      REAL(ReKi), INTENT(IN )      :: z                                               ! Elevation   (-h <= z <= 0 ) (meters)



         ! Compute the hyperbolic numerator over denominator:

      IF (     k   == 0.0  )  THEN  ! When .TRUE., the shallow water formulation is ill-conditioned; thus, HUGE(k) is returned to approximate the known value of infinity.

         COSHNumOvrSIHNDen = HUGE( k )

      ELSEIF ( k*h >  89.4 )  THEN  ! When .TRUE., the shallow water formulation will trigger a floating point overflow error; however, with h > 14.23*wavelength (since k = 2*Pi/wavelength) we can use the numerically-stable deep water formulation instead.

         COSHNumOvrSIHNDen = EXP(  k*z )

      ELSE                          ! 0 < k*h <= 89.4; use the shallow water formulation.

         COSHNumOvrSIHNDen = COSH( k*( z + h ) )/SINH( k*h )

      ENDIF



      RETURN
      END FUNCTION COSHNumOvrSIHNDen
!=======================================================================
      FUNCTION COTH ( X )


         ! This FUNCTION computes the hyperbolic cotangent,
         ! COSH(X)/SINH(X).


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi)                   :: COTH                                            ! This function = COSH( X )/SINH( X ) (-)
      REAL(ReKi), INTENT(IN )      :: X                                               ! The argument (-)



         ! Compute the hyperbolic cotangent:

      IF ( X == 0.0 )  THEN   ! When .TRUE., the formulation below is ill-conditioned; thus, HUGE(X) is returned to approximate the known value of infinity.

         COTH = HUGE( X )

      ELSE                    ! X /= 0.0; use the numerically-stable computation of COTH(X) by means of TANH(X).

         COTH = 1.0/TANH( X ) ! = COSH( X )/SINH( X )

      ENDIF



      RETURN
      END FUNCTION COTH
!=======================================================================
      SUBROUTINE InitCurrent ( CurrMod , CurrSSV0 , CurrSSDir, CurrNSRef, &
                               CurrNSV0, CurrNSDir, CurrDIV  , CurrDIDir, &
                               z       , h        , DirRoot  , CurrVxi  , CurrVyi )


         ! This routine is used to initialize the variables associated with
         ! current.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi), INTENT(IN )      :: CurrDIDir                                       ! Depth-independent current heading direction (degrees)
      REAL(ReKi), INTENT(IN )      :: CurrDIV                                         ! Depth-independent current velocity (m/s)
      REAL(ReKi), INTENT(IN )      :: CurrNSDir                                       ! Near-surface current heading direction (degrees)
      REAL(ReKi), INTENT(IN )      :: CurrNSRef                                       ! Near-surface current reference depth (meters)
      REAL(ReKi), INTENT(IN )      :: CurrNSV0                                        ! Near-surface current velocity at still water level (m/s)
      REAL(ReKi), INTENT(IN )      :: CurrSSDir                                       ! Sub-surface current heading direction (degrees)
      REAL(ReKi), INTENT(IN )      :: CurrSSV0                                        ! Sub-surface current velocity at still water level (m/s)
      REAL(ReKi), INTENT(OUT)      :: CurrVxi                                         ! xi-component of the current velocity at elevation z (m/s)
      REAL(ReKi), INTENT(OUT)      :: CurrVyi                                         ! yi-component of the current velocity at elevation z (m/s)
      REAL(ReKi), INTENT(IN )      :: h                                               ! Water depth (meters)
      REAL(ReKi), INTENT(IN )      :: z                                               ! Elevation relative to the mean sea level (meters)

      INTEGER(4), INTENT(IN )      :: CurrMod                                         ! Current profile model {0: none=no current, 1: standard, 2: user-defined from routine UserCurrent}

      CHARACTER(1024), INTENT(IN ) :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.


         ! Local Variables:

      REAL(ReKi)                   :: CurrSSV                                         ! Magnitude of sub -surface current velocity at elevation z (m/s)
      REAL(ReKi)                   :: CurrNSV                                         ! Magnitude of near-surface current velocity at elevation z (m/s)



         ! If elevation z lies between the seabed and the mean sea level, compute the
         !   xi- and yi-components of the current (which depends on which current
         !   profile model is selected), else set CurrVxi and CurrVyi to zero:

      IF ( ( z < -h ) .OR. ( z > 0.0 ) )  THEN  ! .TRUE. if elevation z lies below the seabed or above mean sea level (exclusive)


            CurrVxi = 0.0  ! Set both the xi- and yi-direction
            CurrVyi = 0.0  ! current velocities to zero


      ELSE                                      ! Elevation z must lie between the seabed and the mean sea level (inclusive)


         SELECT CASE ( CurrMod ) ! Which current profile model are we using?

         CASE ( 0 )              ! None!

            CurrVxi = 0.0  ! Set both the xi- and yi-direction
            CurrVyi = 0.0  ! current velocities to zero


         CASE ( 1 )              ! Standard (using inputs from PtfmFile).

            CurrSSV =      CurrSSV0*( ( z + h         )/h         )**(1.0/7.0)
            CurrNSV = MAX( CurrNSV0*( ( z + CurrNSRef )/CurrNSRef )           , 0.0 )

            CurrVxi = CurrDIV*COS( D2R*CurrDIDir )  + CurrSSV*COS( D2R*CurrSSDir ) + CurrNSV*COS( D2R*CurrNSDir )
            CurrVyi = CurrDIV*SIN( D2R*CurrDIDir )  + CurrSSV*SIN( D2R*CurrSSDir ) + CurrNSV*SIN( D2R*CurrNSDir )


         CASE ( 2 )              ! User-defined current profile model.

            CALL UserCurrent ( z, h, DirRoot, CurrVxi, CurrVyi )


         ENDSELECT


      ENDIF



      RETURN
      END SUBROUTINE InitCurrent
!=======================================================================
      FUNCTION JONSWAP ( Omega, Hs, Tp, Gamma )


         ! This FUNCTION computes the JOint North Sea WAve Project
         ! (JONSWAP) representation of the one-sided power spectral density
         ! or wave spectrum given the frequency, Omega, peak shape
         ! parameter, Gamma, significant wave height, Hs, and peak spectral
         ! period, Tp, as inputs.  If the value of Gamma is 1.0, the
         ! Pierson-Moskowitz wave spectrum is returned.
         !
         ! There are several different versions of the JONSWAP spectrum
         ! formula.  This version is based on the one documented in the
         ! IEC61400-3 wind turbine design standard for offshore wind
         ! turbines.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi), INTENT(IN )      :: Gamma                                           ! Peak shape parameter (-)
      REAL(ReKi), INTENT(IN )      :: Hs                                              ! Significant wave height (meters)
      REAL(ReKi)                   :: JONSWAP                                         ! This function = JONSWAP wave spectrum, S (m^2/(rad/s))
      REAL(ReKi), INTENT(IN )      :: Omega                                           ! Wave frequency (rad/s)
      REAL(ReKi), INTENT(IN )      :: Tp                                              ! Peak spectral period (sec)


         ! Local Variables:

      REAL(ReKi)                   :: Alpha                                           ! Exponent on Gamma used in the spectral formulation (-)
      REAL(ReKi)                   :: C                                               ! Normalising factor used in the spectral formulation (-)
      REAL(ReKi)                   :: f                                               ! Wave frequency (Hz)
      REAL(ReKi)                   :: fp                                              ! Peak spectral frequency (Hz)
      REAL(ReKi)                   :: fpOvrf4                                         ! (fp/f)^4
      REAL(ReKi)                   :: Sigma                                           ! Scaling factor used in the spectral formulation (-)



         ! Compute the JONSWAP wave spectrum, unless Omega is zero, in which case,
         !   return zero:

      IF ( Omega == 0.0 )  THEN  ! When .TRUE., the formulation below is ill-conditioned; thus, the known value of zero is returned.


         JONSWAP  = 0.0


      ELSE                       ! Omega > 0.0; forumulate the JONSWAP spectrum.


         ! Compute the wave frequency and peak spectral frequency in Hz:

         f        = Inv2Pi*Omega
         fp       = 1/Tp
         fpOvrf4  = (fp/f)**4.0


         ! Compute the normalising factor:

         C        = 1.0 - ( 0.287*LOG(GAMMA) )


         ! Compute Alpha:

         IF ( f <= fp )  THEN
            Sigma = 0.07
         ELSE
            Sigma = 0.09
         ENDIF

         Alpha    = EXP( ( -0.5*( ( (f/fp) - 1.0 )/Sigma )**2.0 ) )


         ! Compute the wave spectrum:

         JONSWAP  = Inv2Pi*C*( 0.3125*Hs*Hs*fpOvrf4/f )*EXP( ( -1.25*fpOvrf4 ) )*( GAMMA**Alpha )


      ENDIF



      RETURN
      END FUNCTION JONSWAP
!=======================================================================
      FUNCTION SINHNumOvrSIHNDen ( k, h, z )


         ! This FUNCTION computes the shallow water hyperbolic numerator
         ! over denominator term in the wave kinematics expressions:
         !
         !                    SINH( k*( z + h ) )/SINH( k*h )
         !
         ! given the wave number, k, water depth, h, and elevation z, as
         ! inputs.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi)                   :: SINHNumOvrSIHNDen                               ! This function = SINH( k*( z + h ) )/SINH( k*h ) (-)
      REAL(ReKi), INTENT(IN )      :: h                                               ! Water depth ( h      >  0 ) (meters)
      REAL(ReKi), INTENT(IN )      :: k                                               ! Wave number ( k      >= 0 ) (1/m)
      REAL(ReKi), INTENT(IN )      :: z                                               ! Elevation   (-h <= z <= 0 ) (meters)



         ! Compute the hyperbolic numerator over denominator:

      IF (     k   == 0.0  )  THEN  ! When .TRUE., the shallow water formulation is ill-conditioned; thus, the known value of unity is returned.

         SINHNumOvrSIHNDen = 1.0

      ELSEIF ( k*h >  89.4 )  THEN  ! When .TRUE., the shallow water formulation will trigger a floating point overflow error; however, with h > 14.23*wavelength (since k = 2*Pi/wavelength) we can use the numerically-stable deep water formulation instead.

         SINHNumOvrSIHNDen = EXP(  k*z )

      ELSE                          ! 0 < k*h <= 89.4; use the shallow water formulation.

         SINHNumOvrSIHNDen = SINH( k*( z + h ) )/SINH( k*h )

      ENDIF



      RETURN
      END FUNCTION SINHNumOvrSIHNDen
!=======================================================================
!JASON: MOVE THIS USER-DEFINED ROUTINE (UserCurrent) TO THE UserSubs.f90 OF HydroDyn WHEN THE PLATFORM LOADING FUNCTIONALITY HAS BEEN DOCUMENTED!!!!!
      SUBROUTINE UserCurrent ( zi, WtrDpth, DirRoot, CurrVxi, CurrVyi )


         ! This is a dummy routine for holding the place of a user-specified
         ! current profile.  Modify this code to create your own profile.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi), INTENT(OUT)      :: CurrVxi                                         ! xi-component of the current velocity at elevation zi, m/s.
      REAL(ReKi), INTENT(OUT)      :: CurrVyi                                         ! yi-component of the current velocity at elevation zi, m/s.
      REAL(ReKi), INTENT(IN )      :: WtrDpth                                         ! Water depth ( WtrDpth       >  0 ), meters.
      REAL(ReKi), INTENT(IN )      :: zi                                              ! Elevation   (-WtrDpth <= zi <= 0 ), meters.

      CHARACTER(1024), INTENT(IN ) :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.



      CurrVxi = 0.0
      CurrVyi = 0.0



      RETURN
      END SUBROUTINE UserCurrent
!=======================================================================
!JASON: MOVE THIS USER-DEFINED ROUTINE (UserWaveSpctrm) TO THE UserSubs.f90 OF HydroDyn WHEN THE PLATFORM LOADING FUNCTIONALITY HAS BEEN DOCUMENTED!!!!!
      SUBROUTINE UserWaveSpctrm ( Omega, WaveDir, DirRoot, WaveS1Sdd )


         ! This is a dummy routine for holding the place of a user-specified
         ! wave spectrum.  Modify this code to create your own spectrum.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi), INTENT(IN )      :: Omega                                           ! Wave frequency, rad/s.
      REAL(ReKi), INTENT(IN )      :: WaveDir                                         ! Incident wave propagation heading direction, degrees
      REAL(ReKi), INTENT(OUT)      :: WaveS1Sdd                                       ! One-sided power spectral density of the wave spectrum per unit time for the current frequency component and heading direction, m^2/(rad/s).

      CHARACTER(1024), INTENT(IN ) :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.



      WaveS1Sdd = 0.0



      RETURN
      END SUBROUTINE UserWaveSpctrm
!=======================================================================
      FUNCTION WaveNumber ( Omega, g, h )


         ! This FUNCTION solves the finite depth dispersion relationship:
         !
         !                   k*tanh(k*h)=(Omega^2)/g
         !
         ! for k, the wavenumber (WaveNumber) given the frequency, Omega,
         ! gravitational constant, g, and water depth, h, as inputs.  A
         ! high order initial guess is used in conjunction with a quadratic
         ! Newton's method for the solution with seven significant digits
         ! accuracy using only one iteration pass.  The method is due to
         ! Professor J.N. Newman of M.I.T. as found in routine EIGVAL of
         ! the SWIM-MOTION-LINES (SML) software package in source file
         ! Solve.f of the SWIM module.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi), INTENT(IN )      :: g                                               ! Gravitational acceleration (m/s^2)
      REAL(ReKi), INTENT(IN )      :: h                                               ! Water depth (meters)
      REAL(ReKi), INTENT(IN )      :: Omega                                           ! Wave frequency (rad/s)
      REAL(ReKi)                   :: WaveNumber                                      ! This function = wavenumber, k (1/m)


         ! Local Variables:

      REAL(ReKi)                   :: A                                               ! A temporary variable used in the solution.
      REAL(ReKi)                   :: B                                               ! A temporary variable used in the solution.
      REAL(ReKi)                   :: C                                               ! A temporary variable used in the solution.
      REAL(ReKi)                   :: C2                                              ! A temporary variable used in the solution.
      REAL(ReKi)                   :: CC                                              ! A temporary variable used in the solution.
      REAL(ReKi)                   :: E2                                              ! A temporary variable used in the solution.
      REAL(ReKi)                   :: X0                                              ! A temporary variable used in the solution.



         ! Compute the wavenumber, unless Omega is zero, in which case, return
         !   zero:

      IF ( Omega == 0.0 )  THEN  ! When .TRUE., the formulation below is ill-conditioned; thus, the known value of zero is returned.


         WaveNumber = 0.0


      ELSE                       ! Omega > 0.0; solve for the wavenumber as usual.


         C  = Omega*Omega*h/g
         CC = C*C


         ! Find X0:

         IF ( C <= 2.0 )  THEN

            X0 = SQRT(C)*( 1.0 + C*( 0.169 + (0.031*C) ) )

         ELSE

            E2 = EXP(-2.0*C)

            X0 = C*( 1.0 + ( E2*( 2.0 - (12.0*E2) ) ) )

         ENDIF


         ! Find the WaveNumber:

         IF ( C <= 4.8 )  THEN

            C2 = CC - X0*X0
            A  = 1.0/( C - C2 )
            B  = A*( ( 0.5*LOG( ( X0 + C )/( X0 - C ) ) ) - X0 )

            WaveNumber = ( X0 - ( B*C2*( 1.0 + (A*B*C*X0) ) ) )/h

         ELSE

            WaveNumber = X0/h

         ENDIF


      ENDIF



      RETURN
      END FUNCTION WaveNumber
!=======================================================================
      FUNCTION WheelerStretching ( zOrzPrime, Zeta, h, ForwardOrBackward )


         ! This FUNCTION applies the principle of Wheeler stretching to
         ! (1-Forward) find the elevation where the wave kinematics are to
         ! be applied using Wheeler stretching or (2-Backword) find the
         ! elevation where the wave kinematics are computed before applying
         ! Wheeler stretching.  Wheeler stretching says that wave
         ! kinematics calculated using Airy theory at the mean sea level
         ! should actually be applied at the instantaneous free surface and
         ! that Airy wave kinematics computed at locations between the
         ! seabed and the mean sea level should be shifted vertically to
         ! new locations in proportion to their elevation above the seabed
         ! as follows:
         !
         ! Forward:  z(zPrime,Zeta,h) = ( 1 + Zeta/h )*zPrime + Zeta
         !
         ! or equivalently:
         !
         ! Backword: zPrime(z,Zeta,h) = ( z - Zeta )/( 1 + Zeta/h )
         !
         ! where,
         !   Zeta   = instantaneous elevation of incident waves
         !   h      = water depth
         !   z      = elevations where the wave kinematics are to be
         !            applied using Wheeler stretching
         !   zPrime = elevations where the wave kinematics are computed
         !            before applying Wheeler stretching


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      REAL(ReKi),   INTENT(IN )    :: h                                               ! Water depth (meters)
      REAL(ReKi)                   :: WheelerStretching                               ! This function = zPrime [forward] or z [backward] (meters)
      REAL(ReKi),   INTENT(IN )    :: Zeta                                            ! Instantaneous elevation of incident waves (meters)
      REAL(ReKi),   INTENT(IN )    :: zOrzPrime                                       ! Elevations where the wave kinematics are to be applied using Wheeler stretching, z, [forward] or elevations where the wave kinematics are computed before applying Wheeler stretching, zPrime, [backward] (meters)

      CHARACTER(1), INTENT(IN )    :: ForwardOrBackWard                               ! A string holding the direction ('F'=Forward, 'B'=Backward) for applying Wheeler stretching.



         ! Apply Wheeler stretching, depending on the direction:

      SELECT CASE ( ForwardOrBackWard )

      CASE ( 'F'  )  ! Forward

         WheelerStretching = ( 1.0 + Zeta/h )*zOrzPrime + Zeta


      CASE ( 'B' )   ! Backward

         WheelerStretching = ( zOrzPrime - Zeta )/( 1.0 + Zeta/h )


      CASE DEFAULT

         CALL ProgAbort( 'The last argument in routine WheelerStretching() must be ''F'' or ''B''.' )


      END SELECT



      RETURN
      END FUNCTION WheelerStretching
!=======================================================================
   END SUBROUTINE InitWaves
!=======================================================================
   FUNCTION WaveAcceleration ( IWaveKin, KDirection, ZTime )


      ! This FUNCTION is used to return the acceleration of incident waves
      ! of point IWaveKin in the xi- (KDirection=1), yi- (KDirection=2), or
      ! zi- (KDirection=3) direction, respectively, at time ZTime to the
      ! calling program.

!bjj start of proposed change 6.02d-bjj
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm   USE                             InterpSubs
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   USE                             Precision
!bjj end of propsoed change

   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time (sec)
   REAL(ReKi)                   :: WaveAcceleration                                ! This function = acceleration of incident waves of point IWaveKin in the KDirection-direction at time ZTime (m/s^2)

   INTEGER(4), INTENT(IN )      :: IWaveKin                                        ! Index of the point along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (-)
   INTEGER(4), INTENT(IN )      :: KDirection                                      ! 1, 2, or 3, for the xi-, yi-, or zi-directions, respectively (-)


      ! Local Variables:

   INTEGER(4), SAVE             :: LastInd  = 1                                    ! Index into the arrays saved from the last call as a starting point for this call.


!BJJ START of proposed change v6.02d-bjj
!rm      ! Global functions:
!rm
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm!remove6.02c   REAL(ReKi), EXTERNAL         :: InterpStp                                       ! A generic function to do the actual interpolation.
!rm!remove6.02c
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Abort if the wave kinematics have not been computed yet, if IWaveKin is
      !   not one of the designated points where the incident wave kinematics have
      !   been computed, or if KDirection is not specified properly:

   IF ( .NOT. ALLOCATED ( WaveAcc0 )                           )  THEN
      CALL ProgAbort ( ' Routine InitWaves() must be called before routine WaveAcceleration().' )
   ELSEIF ( ( IWaveKin   < 1 ) .OR. ( IWaveKin   > NWaveKin0 ) )  THEN
      CALL ProgAbort ( ' Point '//TRIM( Int2LStr( IWaveKin ) )//' is not one of the'  // &
                   ' points where the incident wave kinematics have been computed.'         )
   ELSEIF ( ( KDirection < 1 ) .OR. ( KDirection > 3         ) )  THEN
      CALL ProgAbort ( ' KDirection must be 1, 2, or 3 in routine WaveAcceleration().'          )
   ENDIF


      ! Return the wave acceleration:

   WaveAcceleration = InterpStp ( ZTime, WaveTime(:), WaveAcc0(:,IWaveKin,KDirection), LastInd, NStepWave )



   RETURN
   END FUNCTION WaveAcceleration
!=======================================================================
   FUNCTION WaveElevation ( IWaveElev, ZTime )


      ! This FUNCTION is used to return the elevation of incident waves of
      ! point IWaveElev at time ZTime to the calling program.


!bjj start of proposed change 6.02d-bjj
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm   USE                             InterpSubs
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   USE                             Precision
!bjj end of proposed change 6.02d-bjj


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time (sec)
   REAL(ReKi)                   :: WaveElevation                                   ! This function = elevation of incident waves of point IWaveElev at time ZTime (meters)

   INTEGER(4), INTENT(IN )      :: IWaveElev                                       ! Index of the point on the still water level plane where the elevation of incident waves is to be computed (-)


      ! Local Variables:

   INTEGER(4), SAVE             :: LastInd  = 1                                    ! Index into the arrays saved from the last call as a starting point for this call.

!bjj start of proposed change v6.02d-bjj
!rm      ! Global functions:
!rm
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm!remove6.02c   REAL(ReKi), EXTERNAL         :: InterpStp                                       ! A generic function to do the actual interpolation.
!rm!remove6.02c
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Abort if the wave elevation has not been computed yet or if IWaveElev is
      !   not one of the designated points where the incident wave kinematics can
      !   be output:

   IF ( .NOT. ALLOCATED ( WaveElev ) )  THEN
      CALL ProgAbort ( ' Routine InitWaves() must be called before routine WaveElevation().' )
   ELSEIF ( ( IWaveElev < 1 ) .OR. ( IWaveElev > NWaveElev ) )  THEN
      CALL ProgAbort ( ' Point '//TRIM( Int2LStr( IWaveElev ) )//' is not one of the'  // &
                   ' designated points where the wave elevation has been computed.'     )
   ENDIF


      ! Return the wave elevation:

   WaveElevation = InterpStp ( ZTime, WaveTime(:), WaveElev(:,IWaveElev), LastInd, NStepWave )



   RETURN
   END FUNCTION WaveElevation
!=======================================================================
   FUNCTION WavePkShpDefault ( Hs, Tp )


      ! This FUNCTION is used to return the default value of the peak shape
      ! parameter of the incident wave spectrum, conditioned on significant
      ! wave height and peak spectral period.
      !
      ! There are several different versions of the JONSWAP spectrum
      ! formula.  This version is based on the one documented in the
      ! IEC61400-3 wind turbine design standard for offshore wind turbines.


   USE                             Precision


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(IN )      :: Hs                                              ! Significant wave height (meters)
   REAL(ReKi), INTENT(IN )      :: Tp                                              ! Peak spectral period (sec)
   REAL(ReKi)                   :: WavePkShpDefault                                ! This function = default value of the peak shape parameter of the incident wave spectrum conditioned on significant wave height and peak spectral period (-)


      ! Local Variables:

   REAL(ReKi)                   :: TpOvrSqrtHs                                     ! = Tp/SQRT(Hs) (s/SQRT(m))



      ! Compute the default peak shape parameter of the incident wave spectrum,
      !   conditioned on significant wave height and peak spectral period:

   TpOvrSqrtHs = Tp/SQRT(Hs)

   IF (     TpOvrSqrtHs <= 3.6 )  THEN
      WavePkShpDefault = 5.0
   ELSEIF ( TpOvrSqrtHs >= 5.0 )  THEN
      WavePkShpDefault = 1.0
   ELSE
      WavePkShpDefault = EXP( 5.75 - 1.15*TpOvrSqrtHs )
   ENDIF



   RETURN
   END FUNCTION WavePkShpDefault
!=======================================================================
   FUNCTION WaveVelocity ( IWaveKin, KDirection, ZTime )


      ! This FUNCTION is used to return the velocity of incident waves of
      ! point IWaveKin in the xi- (KDirection=1), yi- (KDirection=2), or
      ! zi- (KDirection=3) direction, respectively, at time ZTime to the
      ! calling program.  The values include both the velocity of incident
      ! waves and the velocity of current.

!bjj start of proposed change v6.02d-bjj
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm   USE                             InterpSubs
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   USE                             Precision
!bjj end of proposed change

   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time (sec)
   REAL(ReKi)                   :: WaveVelocity                                    ! This function = velocity of incident waves of point IWaveKin in the KDirection-direction at time ZTime (m/s)

   INTEGER(4), INTENT(IN )      :: IWaveKin                                        ! Index of the point along a vertical line passing through the platform reference point where the incident wave kinematics will be computed (-)
   INTEGER(4), INTENT(IN )      :: KDirection                                      ! 1, 2, or 3, for the xi-, yi-, or zi-directions, respectively (-)


      ! Local Variables:

   INTEGER(4), SAVE             :: LastInd  = 1                                    ! Index into the arrays saved from the last call as a starting point for this call.

!bjj start of proposed change v6.02d-bjj
!rm      ! Global functions:
!rm
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm!remove6.02c   REAL(ReKi), EXTERNAL         :: InterpStp                                       ! A generic function to do the actual interpolation.
!rm!remove6.02c
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Abort if the wave kinematics have not been computed yet, if IWaveKin is
      !   not one of the designated points where the incident wave kinematics have
      !   been computed, or if KDirection is not specified properly:

   IF ( .NOT. ALLOCATED ( WaveVel0 )                           )  THEN
      CALL ProgAbort ( ' Routine InitWaves() must be called before routine WaveVelocity().' )
   ELSEIF ( ( IWaveKin   < 1 ) .OR. ( IWaveKin   > NWaveKin0 ) )  THEN
      CALL ProgAbort ( ' Point '//TRIM( Int2LStr( IWaveKin ) )//' is not one of the'  // &
                   ' points where the incident wave kinematics have been computed.'     )
   ELSEIF ( ( KDirection < 1 ) .OR. ( KDirection > 3         ) )  THEN
      CALL ProgAbort ( ' KDirection must be 1, 2, or 3 in routine WaveVelocity().'          )
   ENDIF


      ! Return the wave velocity:

   WaveVelocity = InterpStp ( ZTime, WaveTime(:), WaveVel0(:,IWaveKin,KDirection), LastInd, NStepWave )



   RETURN
   END FUNCTION WaveVelocity
!=======================================================================
!bjj start of proposed change
   SUBROUTINE Wave_Terminate( )
   
      ! Deallocate arrays
   
   IF ( ALLOCATED(WaveElevC0  ) ) DEALLOCATE(WaveElevC0 )
   IF ( ALLOCATED(DZNodes     ) ) DEALLOCATE(DZNodes    )
   IF ( ALLOCATED(WaveAcc0    ) ) DEALLOCATE(WaveAcc0   )
   IF ( ALLOCATED(WaveElev    ) ) DEALLOCATE(WaveElev   )
   IF ( ALLOCATED(WaveElev0   ) ) DEALLOCATE(WaveElev0  )
   IF ( ALLOCATED(WaveKinzi0  ) ) DEALLOCATE(WaveKinzi0 )
   IF ( ALLOCATED(WaveTime    ) ) DEALLOCATE(WaveTime   )
   IF ( ALLOCATED(WaveVel0    ) ) DEALLOCATE(WaveVel0   )
     
      ! close files
   
   END SUBROUTINE Wave_Terminate

!=======================================================================
!bjj end of proposed change
END MODULE Waves
!=======================================================================
MODULE FloatingPlatform


   ! This MODULE stores variables and routines used in these time domain
   !   hydrodynamic loading and mooring system dynamics routines for the
   !   floating platform.

!bjj start of proposed change v6.02d-bjj
!rmUSE                             Precision
USE                             NWTC_Library
!bjj end of propsoed change

REAL(ReKi)                   :: HdroAdMsI (6,6)                                 ! Infinite-frequency limit of the frequency-dependent hydrodynamic added mass matrix from the radiation problem (kg, kg-m, kg-m^2 )
REAL(ReKi)                   :: HdroSttc  (6,6)                                 ! Linear hydrostatic restoring matrix from waterplane area and the center-of-buoyancy (kg/s^2, kg-m/s^2, kg-m^2/s^2)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
REAL(ReKi), ALLOCATABLE      :: LAnchHTe  (:)                                   ! Effective horizontal tension at the anchor   of each mooring line (N)
REAL(ReKi), ALLOCATABLE      :: LAnchVTe  (:)                                   ! Effective vertical   tension at the anchor   of each mooring line (N)
REAL(ReKi), ALLOCATABLE      :: LAnchxi   (:)                                   ! xi-coordinate of each anchor   in the inertial frame        coordinate system (meters)
REAL(ReKi), ALLOCATABLE      :: LAnchyi   (:)                                   ! yi-coordinate of each anchor   in the inertial frame        coordinate system (meters)
REAL(ReKi), ALLOCATABLE      :: LAnchzi   (:)                                   ! zi-coordinate of each anchor   in the inertial frame        coordinate system (meters)
REAL(ReKi), ALLOCATABLE      :: LEAStff   (:)                                   ! Extensional stiffness of each mooring line (N)
REAL(ReKi), ALLOCATABLE      :: LFairHTe  (:)                                   ! Effective horizontal tension at the fairlead of each mooring line (N)
REAL(ReKi), ALLOCATABLE      :: LFairVTe  (:)                                   ! Effective vertical   tension at the fairlead of each mooring line (N)
REAL(ReKi), ALLOCATABLE      :: LFairxt   (:)                                   ! xt-coordinate of each fairlead in the tower base / platform coordinate system (meters)
REAL(ReKi), ALLOCATABLE      :: LFairyt   (:)                                   ! yt-coordinate of each fairlead in the tower base / platform coordinate system (meters)
REAL(ReKi), ALLOCATABLE      :: LFairzt   (:)                                   ! zt-coordinate of each fairlead in the tower base / platform coordinate system (meters)
REAL(ReKi), ALLOCATABLE      :: LFldWght  (:)                                   ! Weight of each mooring line in fluid per unit length (N/m)
REAL(ReKi), ALLOCATABLE      :: LNodesPi  (:,:,:)                               ! xi- (1), yi- (2), and zi (3) -coordinates in the inertial frame of the position of each node of each line where the line position and tension can be output (meters)
REAL(ReKi), ALLOCATABLE      :: LNodesTe  (:,:)                                 ! Effective line tensions                                                         at each node of each line where the line position and tension can be output (N     )
REAL(ReKi), ALLOCATABLE      :: LNodesX   (:)                                   ! X -coordinates in the local coordinate system of the current line (this coordinate system lies at the current anchor, Z being vertical, and X directed from the current anchor to the current fairlead) of each node where the line position and tension can be output (meters)
REAL(ReKi), ALLOCATABLE      :: LNodesZ   (:)                                   ! Z -coordinates in the local coordinate system of the current line (this coordinate system lies at the current anchor, Z being vertical, and X directed from the current anchor to the current fairlead) of each node where the line position and tension can be output (meters)
REAL(ReKi), ALLOCATABLE      :: LSeabedCD (:)                                   ! Coefficient of seabed static friction drag of each mooring line (a negative value indicates no seabed) (-)
REAL(ReKi), ALLOCATABLE      :: LSNodes   (:,:)                                 ! Unstretched arc distance along mooring line from anchor to each node where the line position and tension can be output (meters)
REAL(ReKi), ALLOCATABLE      :: LTenTol   (:)                                   ! Convergence tolerance within Newton-Raphson iteration of each mooring line specified as a fraction of tension (-)
REAL(ReKi), ALLOCATABLE      :: LUnstrLen (:)                                   ! Unstretched length of each mooring line (meters)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
REAL(ReKi)                   :: PtfmCD                                          ! Effective platform normalized hydrodynamic viscous drag coefficient in calculation of viscous drag term from Morison's equation (-)
REAL(ReKi)                   :: PtfmDiam                                        ! Effective platform diameter in calculation of viscous drag term from Morison's equation (meters)
REAL(ReKi)                   :: PtfmVol0                                        ! Displaced volume of water when the platform is in its undisplaced position (m^3)
REAL(ReKi)                   :: RdtnDT                                          ! Time step for wave radiation kernel calculations (sec)
REAL(ReKi)                   :: RdtnTMax                                        ! Analysis time for wave radiation kernel calculations (sec)
REAL(ReKi), ALLOCATABLE      :: RdtnKrnl  (:,:,:)                               ! Instantaneous values of the wave radiation kernel (kg/s^2, kg-m/s^2, kg-m^2/s^2)
REAL(ReKi), ALLOCATABLE      :: WaveExctn (:,:)                                 ! Instantaneous values of the total excitation force on the support platfrom from incident waves (N, N-m)
REAL(ReKi), ALLOCATABLE      :: XDHistory (:,:)                                 ! The time history of the 3 components of the translational velocity        (in m/s)        of the platform reference and the 3 components of the rotational (angular) velocity  (in rad/s)        of the platform relative to the inertial frame

!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
INTEGER(4)                   :: LineMod                                         ! Mooring line model switch {0: none, 1: standard quasi-static, 2: user-defined from routine UserLine} (switch)
INTEGER(4)                   :: LineNodes                                       ! Number of nodes per line where the mooring line position and tension can be output (-)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
INTEGER(4)                   :: NStepRdtn                                       ! Total number of frequency components = total number of time steps in the wave radiation kernel (-)
INTEGER(4)                   :: NStepRdtn1                                      ! = NStepRdtn + 1 (-)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!jmj Also, put in some logic to ensure that the hydrodynamic loads are time
!jmj   invariant when linearizing a model:
INTEGER(4)                   :: NumLines                                        ! Number of mooring lines (-)

LOGICAL                      :: UseRdtn                                         ! Flag for determining whether or not the to model wave radiation damping (flag)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.


CONTAINS
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!=======================================================================
   SUBROUTINE AnchorTension ( ILine, AnchTe, AnchTeAng )


      ! This SUBROUTINE is used to return the instantaneous effective
      ! tension in, and the vertical angle of, the line at the anchor for
      ! mooring line ILine to the calling program.

!bjj start of proposed change 6.02d-bjj
!this is unnecessary:
!rm   USE                             Precision
!bjj end of proposed change

   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(OUT)      :: AnchTe                                          ! Instantaneous effective tension in the line at the anchor (N  )
   REAL(ReKi), INTENT(OUT)      :: AnchTeAng                                       ! Instantaneous vertical angle    of the line at the anchor (rad)

   INTEGER(4), INTENT(IN )      :: ILine                                           ! Mooring line number (-)

!bjj start of proposed change v6.02d-bjj
!rm      ! Global functions:
!rm
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Abort if the mooring line parameters have not been computed yet or if
      !   ILine is not one of the existing mooring lines:

   IF ( .NOT. ALLOCATED ( LAnchHTe )                )  THEN
      CALL ProgAbort ( ' Routine InitFltngPtfmLd() must be called before routine AnchorTension().' )
   ELSEIF ( ( ILine < 1 ) .OR. ( ILine > NumLines ) )  THEN
      CALL ProgAbort ( ' Mooring line '//TRIM( Int2LStr( ILine ) )//' has not been analyzed.' )
   ENDIF


      ! Return the instantaneous effective tension and angle:

   AnchTe       = SQRT(  LAnchHTe(ILine)*LAnchHTe(ILine) + LAnchVTe(ILine)*LAnchVTe(ILine) )
   IF ( AnchTe == 0.0 )  THEN ! .TRUE. if the effective tension at the anchor is zero so that ATAN2() will be ill-conditioned; return zero instead
      AnchTeAng = 0.0
   ELSE
      AnchTeAng = ATAN2( LAnchVTe(ILine)                 , LAnchHTe(ILine)                 )
   ENDIF



   RETURN
   END SUBROUTINE AnchorTension
!=======================================================================
   SUBROUTINE FairleadTension ( ILine, FairTe, FairTeAng )


      ! This SUBROUTINE is used to return the instantaneous effective
      ! tension in, and the vertical angle of, the line at the fairlead for
      ! mooring line ILine to the calling program.


!bjj start of proposed change 6.02d-bjj
!this is unnecessary:
!rm   USE                             Precision
!bjj end of proposed change


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(OUT)      :: FairTe                                          ! Instantaneous effective tension in the line at the fairlead (N  )
   REAL(ReKi), INTENT(OUT)      :: FairTeAng                                       ! Instantaneous vertical angle    of the line at the fairlead (rad)

   INTEGER(4), INTENT(IN )      :: ILine                                           ! Mooring line number (-)

!bjj start of proposed change v6.02d-bjj
!rm      ! Global functions:
!rm
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed chagne


      ! Abort if the mooring line parameters have not been computed yet or if
      !   ILine is not one of the existing mooring lines:

   IF ( .NOT. ALLOCATED ( LFairHTe )                )  THEN
      CALL ProgAbort ( ' Routine InitFltngPtfmLd() must be called before routine FairleadTension().' )
   ELSEIF ( ( ILine < 1 ) .OR. ( ILine > NumLines ) )  THEN
      CALL ProgAbort ( ' Mooring line '//TRIM( Int2LStr( ILine ) )//' has not been analyzed.' )
   ENDIF


      ! Return the instantaneous effective tension and angle:

   FairTe       = SQRT(  LFairHTe(ILine)*LFairHTe(ILine) + LFairVTe(ILine)*LFairVTe(ILine) )
   IF ( FairTe == 0.0 )  THEN ! .TRUE. if the effective tension at the fairlead is zero so that ATAN2() will be ill-conditioned; return zero instead
      FairTeAng = 0.0
   ELSE
      FairTeAng = ATAN2( LFairVTe(ILine)                 , LFairHTe(ILine)                 )
   ENDIF



   RETURN
   END SUBROUTINE FairleadTension
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
!=======================================================================
   SUBROUTINE FltngPtfmLd ( X, XD, ZTime, PtfmAM, PtfmFt )


      ! This routine implements the time domain hydrodynamic loading and
      ! mooring system dynamics equations for the floating platform.  The
      ! loads from the mooring system are obtained through an interface
      ! with the LINES module of SML and include contributions from
      ! inertia, restoring, and viscous separation damping effects,
      ! including the elastic response of multi-segment lines and their
      ! interaction with the seabed.  The hydrodynamic loads on the support
      ! platform include the restoring contributions of buoyancy and
      ! waterplane area from hydrostatics; the viscous drag contributions
      ! from Morison's equation; the added mass and damping contributions
      ! from radiation, including free surface memory effects; and the
      ! incident wave excitation from diffraction in regular or irregular
      ! seas.  The diffraction, radiation, and hydrostatics problems are
      ! implemented in their true linear form.  Not included in the model
      ! are the effects of vortex-induced vibration and loading from sea
      ! ice, as well as the nonlinear effects of slow-drift and sum-
      ! frequency excitation and high-order wave kinematics.

      ! The order of indices in all arrays passed to and from this routine
      !   is as follows:
      !      1 = Platform surge / xi-component of platform translation (internal DOF index = DOF_Sg)
      !      3 = Platform sway  / yi-component of platform translation (internal DOF index = DOF_Sw)
      !      3 = Platform heave / zi-component of platform translation (internal DOF index = DOF_Hv)
      !      4 = Platform roll  / xi-component of platform rotation    (internal DOF index = DOF_R )
      !      5 = Platform pitch / yi-component of platform rotation    (internal DOF index = DOF_P )
      !      6 = Platform yaw   / zi-component of platform rotation    (internal DOF index = DOF_Y )

      ! NOTE: In extreme wave conditions (i.e., hurricane sea states,
      !       etc.), radiation damping will not be important but Morison's
      !       equation with stretching is very important.  Therefore, these
      !       hydrodynamic loading equations, which are in true linear
      !       form, are limited in their accuracy in such sea conditions.


!bjj start of proposed change v6.02d
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm   USE                             InterpSubs
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   USE                             Precision
!bjj end of proposed change
   USE                             Waves


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(OUT)      :: PtfmAM   (6,6)                                  ! Platform added mass matrix (kg, kg-m, kg-m^2)
   REAL(ReKi), INTENT(OUT)      :: PtfmFt   (6)                                    ! The 3 components of the portion of the platform force (in N  ) acting at the platform reference and the 3 components of the portion of the platform moment (in N-m  ) acting at the platform reference associated with everything but the added-mass effects; positive forces are in the direction of motion
   REAL(ReKi), INTENT(IN )      :: X        (6)                                    ! The 3 components of the translational displacement    (in m  )        of the platform reference and the 3 components of the rotational displacement        (in rad  )        of the platform relative to the inertial frame
   REAL(ReKi), INTENT(IN )      :: XD       (6)                                    ! The 3 components of the translational velocity        (in m/s)        of the platform reference and the 3 components of the rotational (angular) velocity  (in rad/s)        of the platform relative to the inertial frame
   REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time (sec)


      ! Local Variables:

!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi)                   :: COSPhi                                          ! Cosine of the angle between the xi-axis of the inertia frame and the X-axis of the local coordinate system of the current mooring line (-)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   REAL(ReKi)                   :: F_HS     (6)                                    ! Total load contribution from hydrostatics, including the effects of waterplane area and the center of buoyancy (N, N-m)
   REAL(ReKi)                   :: F_Lines  (6)                                    ! Total load contribution from all mooring lines (N, N-m)
   REAL(ReKi)                   :: F_Rdtn   (6)                                    ! Total load contribution from wave radiation damping (i.e., the diffraction problem) (N, N-m)
   REAL(ReKi)                   :: F_RdtnDT (6)                                    ! The portion of the total load contribution from wave radiation damping associated with the convolution integral proportional to ( RdtnDT - RdtnRmndr ) (N, N-m)
   REAL(ReKi)                   :: F_RdtnRmndr(6)                                  ! The portion of the total load contribution from wave radiation damping associated with the convolution integral proportional to (          RdtnRmndr ) (N, N-m)
   REAL(ReKi)                   :: F_Viscous(6)                                    ! Total load contribution from viscous drag (N, N-m)
   REAL(ReKi)                   :: F_Waves  (6)                                    ! Total load contribution from incident waves (i.e., the diffraction problem) (N, N-m)
   REAL(ReKi)                   :: IncrmntXD                                       ! Incremental change in XD over a single radiation time step (m/s, rad/s)
   REAL(ReKi), SAVE             :: LastTime    = 0.0                               ! Last time the values in XDHistory where saved (sec)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!remove6.02b   REAL(ReKi)                   :: Lines    (6,6)                                  ! Linear restoring matrix from all mooring lines (kg/s^2, kg-m/s^2, kg-m^2/s^2)
!remove6.02b   REAL(ReKi)                   :: Lines0   (6)                                    ! Total mooring line load acting on the support platform in its undisplaced position (N, N-m)
   REAL(ReKi)                   :: LFairxi                                         ! xi-coordinate of the current fairlead in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairxiRef                                      ! xi-coordinate of the current fairlead relative to the platform reference point in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairxiTe                                       ! xi-component of the effective tension at the fairlead of the current mooring line (N)
   REAL(ReKi)                   :: LFairyi                                         ! yi-coordinate of the current fairlead in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairyiRef                                      ! yi-coordinate of the current fairlead relative to the platform reference point in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairyiTe                                       ! yi-component of the effective tension at the fairlead of the current mooring line (N)
   REAL(ReKi)                   :: LFairzi                                         ! zi-coordinate of the current fairlead in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairziRef                                      ! zi-coordinate of the current fairlead relative to the platform reference point in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairziTe                                       ! zi-component of the effective tension at the fairlead of the current mooring line (N)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   REAL(ReKi)                   :: MagVRel                                         ! The magnitude of the horizontal incident wave velocity relative to the current platform node at the current time (m/s)
   REAL(ReKi), PARAMETER        :: OnePlusEps  = 1.0 + EPSILON(OnePlusEps)         ! The number slighty greater than unity in the precision of ReKi.
   REAL(ReKi)                   :: PtfmVelocity     (2)                            ! Velocity of the current platform node in the xi- (1) and yi- (2) directions, respectively, at the current time (m/s)
   REAL(ReKi)                   :: RdtnRmndr                                       ! ZTime - RdtnTime(IndRdtn)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi)                   :: SINPhi                                          ! Sine   of the angle between the xi-axis of the inertia frame and the X-axis of the local coordinate system of the current mooring line (-)
   REAL(ReKi)                   :: TransMat (3,3)                                  ! Transformation matrix from the inertial frame to the tower base / platform coordinate system (-)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   REAL(ReKi)                   :: ViscousForce     (2)                            ! Viscous drag force in the xi- (1) and yi- (2) directions, respectively, on the current platform element at the current time (N)
   REAL(ReKi)                   :: WaveVelocity0    (2)                            ! Velocity of incident waves in the xi- (1) and yi- (2) directions, respectively, at the current platform node and time (m/s)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi)                   :: XF                                              ! Horizontal distance between anchor and fairlead of the current mooring line (meters)
   REAL(ReKi)                   :: ZF                                              ! Vertical   distance between anchor and fairlead of the current mooring line (meters)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.

   INTEGER(4)                   :: I                                               ! Generic index
   INTEGER(4)                   :: IndRdtn                                         ! Generic index for the radiation problem
   INTEGER(4)                   :: J                                               ! Generic index
   INTEGER(4)                   :: JNode                                           ! The index of the current platform node / element (-) [1 to PtfmNodes]
   INTEGER(4)                   :: K                                               ! Generic index
   INTEGER(4), SAVE             :: LastIndRdtn                                     ! Index into the radiation     arrays saved from the last call as a starting point for this call.
   INTEGER(4), SAVE             :: LastIndRdtn2                                    ! Index into the radiation     arrays saved from the last call as a starting point for this call.
   INTEGER(4), SAVE             :: LastIndWave = 1                                 ! Index into the incident wave arrays saved from the last call as a starting point for this call.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!jmj   top of source file HydroCalc.f90 in support of improved code
!jmj   optimization:
!remove6.02c
!remove6.02c
!remove6.02c      ! Global functions:
!remove6.02c
!remove6.02c   REAL(ReKi), EXTERNAL         :: InterpStp                                       ! A generic function to do the actual interpolation.
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.




      ! Abort if the wave excitation loads have not been computed yet:

   IF ( .NOT. ALLOCATED ( WaveExctn ) )  &
      CALL ProgAbort ( ' Routine InitFltngPtfmLd() must be called before routine FltngPtfmLd().' )




      ! Compute the load contribution from incident waves (i.e., the diffraction
      !   problem):

   DO I = 1,6     ! Loop through all wave excitation forces and moments
      F_Waves(I) = InterpStp ( ZTime, WaveTime(:), WaveExctn(:,I), LastIndWave, NStepWave )
   ENDDO          ! I - All wave excitation forces and moments




      ! Compute the load contribution from hydrostatics:

   F_HS(:) = 0.0              ! Initialize to zero...
   F_HS(3) = RhoXg*PtfmVol0   ! except for the hydrostatic buoyancy force from Archimede's Principle when the support platform is in its undisplaced position
   DO I = 1,6     ! Loop through all hydrostatic forces and moments
      DO J = 1,6  ! Loop through all platform DOFs
         F_HS(I) = F_HS(I) - HdroSttc(I,J)*X(J)
      ENDDO       ! J - All platform DOFs
   ENDDO          ! I - All hydrostatic forces and moments




!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Put in some logic to ensure that the hydrodynamic loads are time invariant
!jmj   when linearizing a model:
!remove6.02b      ! Compute the load contribution from wave radiation damping (i.e., the
!remove6.02b      !   radiation problem):
      ! If necessary, compute the load contribution from wave radiation damping
      !   (i.e., the radiation problem):

   IF ( UseRdtn )  THEN ! .TRUE. when we will be modeling wave radiation damping.

!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.

      ! Find the index IndRdtn, where RdtnTime(IndRdtn) is the largest value in
      !   RdtnTime(:) that is less than or equal to ZTime and find the amount of
      !   time remaining from this calculation:
      ! NOTE: ZTime is scaled by OnePlusEps to ensure that IndRdtn increments in
      !       steps of 1 when RdtnDT = DT, even in the presence of numerical
      !       precision errors.

      IndRdtn   = FLOOR ( ( ZTime*OnePlusEps )/RdtnDT )
      RdtnRmndr = ZTime - ( IndRdtn*RdtnDT ) ! = ZTime - RdtnTime(IndRdtn); however, RdtnTime(:) has a maximum index of NStepRdtn-1


      ! Save the new values of XD in XDHistory if:
      !   (1) we are on the initialization pass where ZTime = 0.0,
      !   (2) we have increased in time by at least RdtnDT, or
      !   (3) the time has not changed since the last time we have increased in
      !       time by at least RdtnDT (i.e., on a call to the corrector)
      !   When saving the new values, interpolate to find all of the values
      !   between index LastIndRdtn and index IndRdtn.  Also, if the XDHistory
      !   array is full, use MOD(Index,NStepRdtn1) to replace the oldest values
      !   with the newest values:
      ! NOTE: When IndRdtn > LastIndRdtn, IndRdtn will equal           LastIndRdtn + 1 if DT <= RdtnDT;
      !       When IndRdtn > LastIndRdtn, IndRdtn will be greater than LastIndRdtn + 1 if DT >  RdtnDT.

      IF ( ZTime == 0.0 )  THEN              ! (1) .TRUE. if we are on the initialization pass where ZTime = 0.0 (and IndRdtn = 0)

         DO J = 1,6  ! Loop through all platform DOFs
            XDHistory(IndRdtn,J) = XD(J)
         ENDDO       ! J - All platform DOFs

         LastIndRdtn  =     IndRdtn       ! Save the value of                           IndRdtn for the next call to this routine (in this case IndRdtn = 0)

      ELSEIF ( IndRdtn > LastIndRdtn )  THEN ! (2) .TRUE. if we have increased in time by at least RdtnDT

         DO J = 1,6                       ! Loop through all platform DOFs

            IncrmntXD = ( RdtnDT/( ZTime - ( LastIndRdtn *RdtnDT ) ) )*( XD(J) - XDHistory(MOD(LastIndRdtn ,NStepRdtn1),J) )

            DO K = LastIndRdtn +1,IndRdtn ! Loop through all radiation time steps where the time history of XD has yet to be stored
               XDHistory(MOD(K,NStepRdtn1),J) = XDHistory(MOD(LastIndRdtn ,NStepRdtn1),J) + ( K - LastIndRdtn  )*IncrmntXD
            ENDDO                         ! K - All radiation time steps where the time history of XD has yet to be stored

         ENDDO                            ! J - All platform DOFs

         LastIndRdtn2 = LastIndRdtn       ! Save the value of                       LastIndRdtn for the next call to this routine
         LastIndRdtn  =     IndRdtn       ! Save the value of                           IndRdtn for the next call to this routine
         LastTime     = ZTime             ! Save the value of ZTime associated with LastIndRdtn for the next call to this routine

      ELSEIF ( ZTime == LastTime )  THEN     ! (3). .TRUE. if the time has not changed since the last time we have increased in time by at least RdtnDt (i.e., on a call to the corrector)

         DO J = 1,6                       ! Loop through all platform DOFs

            IncrmntXD = ( RdtnDT/( ZTime - ( LastIndRdtn2*RdtnDT ) ) )*( XD(J) - XDHistory(MOD(LastIndRdtn2,NStepRdtn1),J) )

            DO K = LastIndRdtn2+1,IndRdtn ! Loop through all radiation time steps where the time history of XD should be updated
               XDHistory(MOD(K,NStepRdtn1),J) = XDHistory(MOD(LastIndRdtn2,NStepRdtn1),J) + ( K - LastIndRdtn2 )*IncrmntXD
            ENDDO                         ! K - All radiation time steps where the time history of XD should be updated

         ENDDO                            ! J - All platform DOFs

      ENDIF


      ! Perform numerical convolution to determine the load contribution from wave
      !   radiation damping:

      DO I = 1,6                 ! Loop through all wave radiation damping forces and moments

         F_RdtnDT   (I) = 0.0
         F_RdtnRmndr(I) = 0.0

         DO J = 1,6              ! Loop through all platform DOFs

            DO K = MAX(0,IndRdtn-NStepRdtn  ),IndRdtn-1  ! Loop through all NStepRdtn time steps in the radiation Kernel (less than NStepRdtn time steps are used when ZTime < RdtnTmax)
               F_RdtnDT   (I) = F_RdtnDT   (I) - RdtnKrnl(IndRdtn-1-K,I,J)*XDHistory(MOD(K,NStepRdtn1),J)
            ENDDO                                        ! K - All NStepRdtn time steps in the radiation Kernel (less than NStepRdtn time steps are used when ZTime < RdtnTmax)

            DO K = MAX(0,IndRdtn-NStepRdtn+1),IndRdtn    ! Loop through all NStepRdtn time steps in the radiation Kernel (less than NStepRdtn time steps are used when ZTime < RdtnTmax)
               F_RdtnRmndr(I) = F_RdtnRmndr(I) - RdtnKrnl(IndRdtn  -K,I,J)*XDHistory(MOD(K,NStepRdtn1),J)
            ENDDO                                        ! K - All NStepRdtn time steps in the radiation Kernel (less than NStepRdtn time steps are used when ZTime < RdtnTmax)

         ENDDO                   ! J - All platform DOFs

         F_Rdtn     (I) = ( RdtnDT - RdtnRmndr )*F_RdtnDT(I) + RdtnRmndr*F_RdtnRmndr(I)

      ENDDO                      ! I - All wave radiation damping forces and moments
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Put in some logic to ensure that the hydrodynamic loads are time invariant
!jmj   when linearizing a model:


   ELSE                 ! We must not be modeling wave radiation damping.


      ! Set the total load contribution from radiation damping to zero:

      F_Rdtn        (:) = 0.0


   ENDIF
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.




      ! Compute the load contribution from viscous drag using the viscous drag
      !   term from Morison's equation:
      ! NOTE: It is inconsistent to use stretching (which is a nonlinear
      !       correction) for the viscous drag term in Morison's equation while
      !       not accounting for stretching in the diffraction and radiation
      !       problems (according to Paul Sclavounos, there are such corrections).
      !       Instead, the viscous drag term from Morison's equation is computed
      !       by integrating up to the MSL, regardless of the instantaneous free
      !       surface elevation.  Also, the undisplaced platform location and
      !       orientation are used in the calculations (when finding the incident
      !       wave velocity relative to the current platform node, for example)
      !       because this is the approach most consistent with the linearized
      !       implementation of the diffraction and radiation problems.  Finally,
      !       the viscous drag load only contains components in the surge, sway,
      !       pitch, and roll directions.  There is no viscous drag in the heave
      !       or yaw directions.

   F_Viscous = 0.0   ! First initialize this force to zero.

   DO JNode = 1,NWaveKin0  ! Loop through the platform nodes / elements


      ! Compute the velocity of the incident waves in the xi- (1) and yi- (2)
      !   directions, respectively, at the current platform node and time:

      DO K = 1,2     ! Loop through the xi- (1) and yi- (2) directions
         WaveVelocity0(K) = WaveVelocity ( JNode, K, ZTime )
      ENDDO          ! K - The xi- (1) and yi- (2) directions


      ! Compute the velocity of the current platform node in the xi- (1) and yi-
      !   (2) directions, respectively, at the current time:

      PtfmVelocity(1) = XD(1) + XD(5)*WaveKinzi0(JNode)
      PtfmVelocity(2) = XD(2) - XD(4)*WaveKinzi0(JNode)


      ! Compute the magnitude of the horizontal incident wave velocity relative to
      !   the current platform node at the current time:

      MagVRel = SQRT(   ( WaveVelocity0(1) - PtfmVelocity(1) )**2 &
                      + ( WaveVelocity0(2) - PtfmVelocity(2) )**2   )


      ! Compute the viscous drag force in the xi- (1) and yi- (2) directions,
      !   respectively, on the current platform element at the current time:

      DO K = 1,2     ! Loop through the xi- (1) and yi- (2) directions
         ViscousForce (K) = 0.5*PtfmCD*WtrDens*PtfmDiam*( WaveVelocity0(K) - PtfmVelocity(K) )*MagVRel*DZNodes(JNode)
      ENDDO          ! K - The xi- (1) and yi- (2) directions


      ! Compute the portion of the viscous drag load on the platform associated
      !   with the current element:

      F_Viscous(1) = F_Viscous(1) + ViscousForce(1)                     ! surge component
      F_Viscous(2) = F_Viscous(2) + ViscousForce(2)                     ! sway  component
      F_Viscous(4) = F_Viscous(4) - ViscousForce(2)*WaveKinzi0(JNode)   ! roll  component
      F_Viscous(5) = F_Viscous(5) + ViscousForce(1)*WaveKinzi0(JNode)   ! pitch component


   ENDDO                   ! JNode - Platform nodes / elements




      ! Compute the load contribution from mooring lines:

!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!remove6.02b   Lines0(1)   =         0.0
!remove6.02b   Lines0(2)   =         0.0
!remove6.02b   Lines0(3)   = -41050000.0
!remove6.02b   Lines0(4)   =         0.0
!remove6.02b   Lines0(5)   =         0.0
!remove6.02b   Lines0(6)   =         0.0
!remove6.02b
!remove6.02b   Lines (1,:) = (/    907000.0,        0.0,         0.0,           0.0,   -16100000.0,        0.0 /)
!remove6.02b   Lines (2,:) = (/         0.0,   907000.0,         0.0,    16100000.0,           0.0,        0.0 /)
!remove6.02b   Lines (3,:) = (/         0.0,        0.0, 213000000.0,           0.0,           0.0,        0.0 /)
!remove6.02b   Lines (4,:) = (/         0.0, 15600000.0,         0.0, 10600000000.0,           0.0,        0.0 /)
!remove6.02b   Lines (5,:) = (/ -15600000.0,        0.0,         0.0,           0.0, 10600000000.0,        0.0 /)
!remove6.02b   Lines (6,:) = (/         0.0,        0.0,         0.0,           0.0,           0.0, 82900000.0 /)
!remove6.02b
!remove6.02b   DO I = 1,6     ! Loop through all mooring line forces and moments
!remove6.02b         F_Lines(I) = Lines0 (I)
!remove6.02b      DO J = 1,6  ! Loop through all platform DOFs
!remove6.02b         F_Lines(I) = F_Lines(I) - Lines(I,J)*X(J)
!remove6.02b      ENDDO       ! J - All platform DOFs
!remove6.02b   ENDDO          ! I - All mooring line forces and moments
   SELECT CASE ( LineMod ) ! Which incident wave kinematics model are we using?

   CASE ( 0 )              ! None.


      ! Set the total load contribution from all mooring lines to zero:

      F_Lines(:) = 0.0



   CASE ( 1 )              ! Standard quasi-static.


      ! First initialize the total load contribution from all mooring lines to
      !   zero:

      F_Lines(:) = 0.0


      ! Get the transformation matrix, TransMat, from the inertial frame to the
      !   tower base / platform coordinate system:

      CALL SmllRotTrans ( 'platform displacement', X(4), X(5), X(6), TransMat )


      DO I = 1,NumLines ! Loop through all mooring lines


      ! Transform the fairlead location from the platform to the inertial
      !   frame coordinate system:
      ! NOTE: TransMat^T = TransMat^-1 where ^T = matrix transpose and ^-1 =
      !       matrix inverse.

         LFairxiRef = TransMat(1,1)*LFairxt(I) + TransMat(2,1)*LFairyt(I) + TransMat(3,1)*LFairzt(I)
         LFairyiRef = TransMat(1,2)*LFairxt(I) + TransMat(2,2)*LFairyt(I) + TransMat(3,2)*LFairzt(I)
         LFairziRef = TransMat(1,3)*LFairxt(I) + TransMat(2,3)*LFairyt(I) + TransMat(3,3)*LFairzt(I)

         LFairxi    = X(1) + LFairxiRef
         LFairyi    = X(2) + LFairyiRef
         LFairzi    = X(3) + LFairziRef


      ! Transform the fairlead location from the inertial frame coordinate system
      !   to the local coordinate system of the current line (this coordinate
      !   system lies at the current anchor, Z being vertical, and X directed from
      !   current anchor to the current fairlead).  Also, compute the orientation
      !   of this local coordinate system:

         XF         = SQRT( ( LFairxi - LAnchxi(I) )**2.0 + ( LFairyi - LAnchyi(I) )**2.0 )
         ZF         =         LFairzi - LAnchzi(I)

         IF ( XF == 0.0 )  THEN  ! .TRUE. if the current mooring line is exactly vertical; thus, the solution below is ill-conditioned because the orientation is undefined; so set it such that the tensions and nodal positions are only vertical
            COSPhi  = 0.0
            SINPhi  = 0.0
         ELSE                    ! The current mooring line must not be vertical; use simple trigonometry
            COSPhi  =       ( LFairxi - LAnchxi(I) )/XF
            SINPhi  =       ( LFairyi - LAnchyi(I) )/XF
         ENDIF


      ! Solve the analytical, static equilibrium equations for a catenary (or
      !   taut) mooring line with seabed interaction in order to find the
      !   horizontal and vertical tensions at the fairlead in the local coordinate
      !   system of the current line:
      ! NOTE: The values for the horizontal and vertical tensions at the fairlead
      !       from the previous time step are used as the initial guess values at
      !       at this time step (because the LAnchHTe(:) and LAnchVTe(:) arrays
      !       are stored in a module and thus their values are saved from CALL to
      !       CALL).

         CALL Catenary ( XF           , ZF          , LUnstrLen(I), LEAStff  (I)  , &
                         LFldWght(I)  , LSeabedCD(I), LTenTol  (I), LFairHTe (I)  , &
                         LFairVTe(I)  , LAnchHTe (I), LAnchVTe (I), LineNodes     , &
                         LSNodes (I,:), LNodesX  (:), LNodesZ  (:), LNodesTe (I,:)    )


      ! Transform the positions of each node on the current line from the local
      !   coordinate system of the current line to the inertial frame coordinate
      !   system:

         DO J = 1,LineNodes ! Loop through all nodes per line where the line position and tension can be output
            LNodesPi(I,J,1) = LAnchxi(I) + LNodesX(J)*COSPhi
            LNodesPi(I,J,2) = LAnchyi(I) + LNodesX(J)*SINPhi
            LNodesPi(I,J,3) = LAnchzi(I) + LNodesZ(J)
         ENDDO              ! J - All nodes per line where the line position and tension can be output


      ! Compute the portion of the mooring system load on the platform associated
      !   with the current line:

         LFairxiTe  = LFairHTe(I)*COSPhi
         LFairyiTe  = LFairHTe(I)*SINPhi
         LFairziTe  = LFairVTe(I)

         F_Lines(1) = F_Lines(1) -            LFairxiTe
         F_Lines(2) = F_Lines(2) -            LFairyiTe
         F_Lines(3) = F_Lines(3) -            LFairziTe
         F_Lines(4) = F_Lines(4) - LFairyiRef*LFairziTe + LFairziRef*LFairyiTe
         F_Lines(5) = F_Lines(5) - LFairziRef*LFairxiTe + LFairxiRef*LFairziTe
         F_Lines(6) = F_Lines(6) - LFairxiRef*LFairyiTe + LFairyiRef*LFairxiTe


      ENDDO             ! I - All mooring lines



   CASE ( 2 )              ! User-defined mooring lines.


      ! CALL the user-defined platform loading model:

      CALL UserLine ( X              , ZTime    , DirRoot        , F_Lines        , &
                      NumLines       , LineNodes, LFairHTe       , LFairVTe       , &
                      LAnchHTe       , LAnchVTe , LNodesPi(:,:,1), LNodesPi(:,:,2), &
                      LNodesPi(:,:,3), LNodesTe                         )



   ENDSELECT
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.




      ! Total up all of the loads that do not depend on platform acceleration:

   PtfmFt = F_Waves + F_HS + F_Rdtn + F_Viscous + F_Lines   ! This is an array operation.




      ! Set the platform added mass matrix, PtfmAM, to be the infinite-frequency
      !   limit of the frequency-dependent hydrodynamic added mass matrix,
      !   HdroAdMsI:

   PtfmAM = HdroAdMsI   ! This is an array operation.




!JASON: USE THIS TO TEST RELATIVE MAGNITUDES:WRITE (*,*) ZTime, F_Waves(5), F_Rdtn(5), F_Viscous(5), F_Lines(5)   !JASON:USE THIS TO TEST RELATIVE MAGNITUDES:
   RETURN
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   CONTAINS
!=======================================================================
!JASON: SHOULD THIS ROUTINE (Catenary) BE PLACED IN NWTC_Subs OR IN ITS OWN DLL?
      SUBROUTINE Catenary ( XF_In, ZF_In, L_In  , EA_In, &
                            W_In , CB_In, Tol_In, HF_In, &
                            VF_In, HA_In, VA_In , N    , &
                            s_In , X_In , Z_In  , Te_In    )


         ! This routine solves the analytical, static equilibrium equations
         ! for a catenary (or taut) mooring line with seabed interaction.
         ! Stretching of the line is accounted for, but bending stiffness
         ! is not.  Given the mooring line properties and the fairlead
         ! position relative to the anchor, this routine finds the line
         ! configuration and tensions.  Since the analytical solution
         ! involves two nonlinear equations (XF and  ZF) in two unknowns
         ! (HF and VF), a Newton-Raphson iteration scheme is implemented in
         ! order to solve for the solution.  The values of HF and VF that
         ! are passed into this routine are used as the initial guess in
         ! the iteration.  The Newton-Raphson iteration is only accurate in
         ! double precision, so all of the input/output arguments are
         ! converteds to/from double precision from/to default precision.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      INTEGER(4), INTENT(IN   )    :: N                                               ! Number of nodes where the line position and tension can be output (-)

      REAL(ReKi), INTENT(IN   )    :: CB_In                                           ! Coefficient of seabed static friction drag (a negative value indicates no seabed) (-)
      REAL(ReKi), INTENT(IN   )    :: EA_In                                           ! Extensional stiffness of line (N)
      REAL(ReKi), INTENT(  OUT)    :: HA_In                                           ! Effective horizontal tension in line at the anchor   (N)
      REAL(ReKi), INTENT(INOUT)    :: HF_In                                           ! Effective horizontal tension in line at the fairlead (N)
      REAL(ReKi), INTENT(IN   )    :: L_In                                            ! Unstretched length of line (meters)
      REAL(ReKi), INTENT(IN   )    :: s_In     (N)                                    ! Unstretched arc distance along line from anchor to each node where the line position and tension can be output (meters)
      REAL(ReKi), INTENT(  OUT)    :: Te_In    (N)                                    ! Effective line tensions at each node (N)
      REAL(ReKi), INTENT(IN   )    :: Tol_In                                          ! Convergence tolerance within Newton-Raphson iteration specified as a fraction of tension (-)
      REAL(ReKi), INTENT(  OUT)    :: VA_In                                           ! Effective vertical   tension in line at the anchor   (N)
      REAL(ReKi), INTENT(INOUT)    :: VF_In                                           ! Effective vertical   tension in line at the fairlead (N)
      REAL(ReKi), INTENT(IN   )    :: W_In                                            ! Weight of line in fluid per unit length (N/m)
      REAL(ReKi), INTENT(  OUT)    :: X_In     (N)                                    ! Horizontal locations of each line node relative to the anchor (meters)
      REAL(ReKi), INTENT(IN   )    :: XF_In                                           ! Horizontal distance between anchor and fairlead (meters)
      REAL(ReKi), INTENT(  OUT)    :: Z_In     (N)                                    ! Vertical   locations of each line node relative to the anchor (meters)
      REAL(ReKi), INTENT(IN   )    :: ZF_In                                           ! Vertical   distance between anchor and fairlead (meters)


         ! Local Variables:

      REAL(DbKi)                   :: CB                                              ! Coefficient of seabed static friction (a negative value indicates no seabed) (-)
      REAL(DbKi)                   :: CBOvrEA                                         ! = CB/EA
      REAL(DbKi)                   :: DET                                             ! Determinant of the Jacobian matrix (m^2/N^2)
      REAL(DbKi)                   :: dHF                                             ! Increment in HF predicted by Newton-Raphson (N)
      REAL(DbKi)                   :: dVF                                             ! Increment in VF predicted by Newton-Raphson (N)
      REAL(DbKi)                   :: dXFdHF                                          ! Partial derivative of the calculated horizontal distance with respect to the horizontal fairlead tension (m/N): dXF(HF,VF)/dHF
      REAL(DbKi)                   :: dXFdVF                                          ! Partial derivative of the calculated horizontal distance with respect to the vertical   fairlead tension (m/N): dXF(HF,VF)/dVF
      REAL(DbKi)                   :: dZFdHF                                          ! Partial derivative of the calculated vertical   distance with respect to the horizontal fairlead tension (m/N): dZF(HF,VF)/dHF
      REAL(DbKi)                   :: dZFdVF                                          ! Partial derivative of the calculated vertical   distance with respect to the vertical   fairlead tension (m/N): dZF(HF,VF)/dVF
      REAL(DbKi)                   :: EA                                              ! Extensional stiffness of line (N)
      REAL(DbKi)                   :: EXF                                             ! Error function between calculated and known horizontal distance (meters): XF(HF,VF) - XF
      REAL(DbKi)                   :: EZF                                             ! Error function between calculated and known vertical   distance (meters): ZF(HF,VF) - ZF
      REAL(DbKi)                   :: HA                                              ! Effective horizontal tension in line at the anchor   (N)
      REAL(DbKi)                   :: HF                                              ! Effective horizontal tension in line at the fairlead (N)
      REAL(DbKi)                   :: HFOvrW                                          ! = HF/W
      REAL(DbKi)                   :: HFOvrWEA                                        ! = HF/WEA
      REAL(DbKi)                   :: L                                               ! Unstretched length of line (meters)
      REAL(DbKi)                   :: Lamda0                                          ! Catenary parameter used to generate the initial guesses of the horizontal and vertical tensions at the fairlead for the Newton-Raphson iteration (-)
      REAL(DbKi)                   :: LMax                                            ! Maximum stretched length of the line with seabed interaction beyond which the line would have to double-back on itself; here the line forms an "L" between the anchor and fairlead (i.e. it is horizontal along the seabed from the anchor, then vertical to the fairlead) (meters)
      REAL(DbKi)                   :: LMinVFOvrW                                      ! = L - VF/W
      REAL(DbKi)                   :: LOvrEA                                          ! = L/EA
      REAL(DbKi)                   :: s        (N)                                    ! Unstretched arc distance along line from anchor to each node where the line position and tension can be output (meters)
      REAL(DbKi)                   :: sOvrEA                                          ! = s(I)/EA
      REAL(DbKi)                   :: SQRT1VFOvrHF2                                   ! = SQRT( 1.0_DbKi + VFOvrHF2      )
      REAL(DbKi)                   :: SQRT1VFMinWLOvrHF2                              ! = SQRT( 1.0_DbKi + VFMinWLOvrHF2 )
      REAL(DbKi)                   :: SQRT1VFMinWLsOvrHF2                             ! = SQRT( 1.0_DbKi + VFMinWLsOvrHF*VFMinWLsOvrHF )
      REAL(DbKi)                   :: Te       (N)                                    ! Effective line tensions at each node (N)
      REAL(DbKi)                   :: Tol                                             ! Convergence tolerance within Newton-Raphson iteration specified as a fraction of tension (-)
      REAL(DbKi)                   :: VA                                              ! Effective vertical   tension in line at the anchor   (N)
      REAL(DbKi)                   :: VF                                              ! Effective vertical   tension in line at the fairlead (N)
      REAL(DbKi)                   :: VFMinWL                                         ! = VF - WL
      REAL(DbKi)                   :: VFMinWLOvrHF                                    ! = VFMinWL/HF
      REAL(DbKi)                   :: VFMinWLOvrHF2                                   ! = VFMinWLOvrHF*VFMinWLOvrHF
      REAL(DbKi)                   :: VFMinWLs                                        ! = VFMinWL + Ws
      REAL(DbKi)                   :: VFMinWLsOvrHF                                   ! = VFMinWLs/HF
      REAL(DbKi)                   :: VFOvrHF                                         ! = VF/HF
      REAL(DbKi)                   :: VFOvrHF2                                        ! = VFOvrHF*VFOvrHF
      REAL(DbKi)                   :: VFOvrWEA                                        ! = VF/WEA
      REAL(DbKi)                   :: W                                               ! Weight of line in fluid per unit length (N/m)
      REAL(DbKi)                   :: WEA                                             ! = W*EA
      REAL(DbKi)                   :: WL                                              ! Total weight of line in fluid (N): W*L
      REAL(DbKi)                   :: Ws                                              ! = W*s(I)
      REAL(DbKi)                   :: X        (N)                                    ! Horizontal locations of each line node relative to the anchor (meters)
      REAL(DbKi)                   :: XF                                              ! Horizontal distance between anchor and fairlead (meters)
      REAL(DbKi)                   :: XF2                                             ! = XF*XF
      REAL(DbKi)                   :: Z        (N)                                    ! Vertical   locations of each line node relative to the anchor (meters)
      REAL(DbKi)                   :: ZF                                              ! Vertical   distance between anchor and fairlead (meters)
      REAL(DbKi)                   :: ZF2                                             ! = ZF*ZF

      INTEGER(4)                   :: I                                               ! Index for counting iterations or looping through line nodes (-)
      INTEGER(4)                   :: MaxIter                                         ! Maximum number of Newton-Raphson iterations possible before giving up (-)

      LOGICAL                      :: FirstIter                                       ! Flag to determine whether or not this is the first time through the Newton-Raphson interation (flag)



         ! The Newton-Raphson iteration is only accurate in double precision, so
         !   convert the input arguments into double precision:

      CB     = REAL( CB_In    , DbKi )
      EA     = REAL( EA_In    , DbKi )
      HF     = REAL( HF_In    , DbKi )
      L      = REAL( L_In     , DbKi )
      s  (:) = REAL( s_In  (:), DbKi )
      Tol    = REAL( Tol_In   , DbKi )
      VF     = REAL( VF_In    , DbKi )
      W      = REAL( W_In     , DbKi )
      XF     = REAL( XF_In    , DbKi )
      ZF     = REAL( ZF_In    , DbKi )



         ! Abort when there is no solution or when the only possible solution is
         !   illogical:

      IF (    Tol <= 0.0_DbKi )  THEN   ! .TRUE. when the convergence tolerance is specified incorrectly

         CALL ProgAbort ( ' Convergence tolerance must be greater than zero in routine Catenary().' )


      ELSEIF ( XF <  0.0_DbKi )  THEN   ! .TRUE. only when the local coordinate system is not computed correctly

         CALL ProgAbort ( ' The horizontal distance between an anchor and its'// &
                      ' fairlead must not be less than zero in routine Catenary().' )


      ELSEIF ( ZF <  0.0_DbKi )  THEN   ! .TRUE. if the fairlead has passed below its anchor

         CALL ProgAbort ( ' A fairlead has passed below its anchor.' )


      ELSEIF ( L  <= 0.0_DbKi )  THEN   ! .TRUE. when the unstretched line length is specified incorrectly

         CALL ProgAbort ( ' Unstretched length of line must be greater than zero in routine Catenary().' )


      ELSEIF ( EA <= 0.0_DbKi )  THEN   ! .TRUE. when the unstretched line length is specified incorrectly

         CALL ProgAbort ( ' Extensional stiffness of line must be greater than zero in routine Catenary().' )


      ELSEIF ( W  == 0.0_DbKi )  THEN   ! .TRUE. when the weight of the line in fluid is zero so that catenary solution is ill-conditioned

         CALL ProgAbort ( ' The weight of the line in fluid must not be zero. '// &
                      ' Routine Catenary() cannot solve quasi-static mooring line solution.' )


      ELSEIF ( W  >  0.0_DbKi )  THEN   ! .TRUE. when the line will sink in fluid

         LMax      = XF - EA/W + SQRT( (EA/W)*(EA/W) + 2.0_DbKi*ZF*EA/W )  ! Compute the maximum stretched length of the line with seabed interaction beyond which the line would have to double-back on itself; here the line forms an "L" between the anchor and fairlead (i.e. it is horizontal along the seabed from the anchor, then vertical to the fairlead)

         IF ( ( L  >=  LMax   ) .AND. ( CB >= 0.0_DbKi ) )  &  ! .TRUE. if the line is as long or longer than its maximum possible value with seabed interaction
            CALL ProgAbort ( ' Unstretched mooring line length too large. '// &
                         ' Routine Catenary() cannot solve quasi-static mooring line solution.' )


      ENDIF



         ! Initialize some commonly used terms that don't depend on the iteration:

      WL      =          W  *L
      WEA     =          W  *EA
      LOvrEA  =          L  /EA
      CBOvrEA =          CB /EA
      MaxIter = INT(1.0_DbKi/Tol)   ! Smaller tolerances may take more iterations, so choose a maximum inversely proportional to the tolerance



         ! To avoid an ill-conditioned situation, ensure that the initial guess for
         !   HF is not less than or equal to zero.  Similarly, avoid the problems
         !   associated with having exactly vertical (so that HF is zero) or exactly
         !   horizontal (so that VF is zero) lines by setting the minimum values
         !   equal to the tolerance.  This prevents us from needing to implement
         !   the known limiting solutions for vertical or horizontal lines (and thus
         !   complicating this routine):

      HF = MAX( HF, Tol )
      XF = MAX( XF, Tol )
      ZF = MAX( ZF, TOl )



         ! Solve the analytical, static equilibrium equations for a catenary (or
         !   taut) mooring line with seabed interaction:

         ! Begin Newton-Raphson iteration:

      I         = 1        ! Initialize iteration counter
      FirstIter = .TRUE.   ! Initialize iteration flag

      DO


         ! Initialize some commonly used terms that depend on HF and VF:

         VFMinWL            = VF - WL
         LMinVFOvrW         = L  - VF/W
         HFOvrW             =      HF/W
         HFOvrWEA           =      HF/WEA
         VFOvrWEA           =      VF/WEA
         VFOvrHF            =      VF/HF
         VFMinWLOvrHF       = VFMinWL/HF
         VFOvrHF2           = VFOvrHF     *VFOvrHF
         VFMinWLOvrHF2      = VFMinWLOvrHF*VFMinWLOvrHF
         SQRT1VFOvrHF2      = SQRT( 1.0_DbKi + VFOvrHF2      )
         SQRT1VFMinWLOvrHF2 = SQRT( 1.0_DbKi + VFMinWLOvrHF2 )


         ! Compute the error functions (to be zeroed) and the Jacobian matrix
         !   (these depend on the anticipated configuration of the mooring line):

         IF ( ( CB <  0.0_DbKi ) .OR. ( W  <  0.0_DbKi ) .OR. ( VFMinWL >  0.0_DbKi ) )  THEN   ! .TRUE. when no portion of the line      rests on the seabed

            EXF    = (   LOG( VFOvrHF      +               SQRT1VFOvrHF2      )                                       &
                       - LOG( VFMinWLOvrHF +               SQRT1VFMinWLOvrHF2 )                                         )*HFOvrW &
                   + LOvrEA*  HF                         - XF
            EZF    = (                                     SQRT1VFOvrHF2                                              &
                       -                                   SQRT1VFMinWLOvrHF2                                           )*HFOvrW &
                   + LOvrEA*( VF - 0.5_DbKi*WL )         - ZF

            dXFdHF = (   LOG( VFOvrHF      +               SQRT1VFOvrHF2      )                                       &
                       - LOG( VFMinWLOvrHF +               SQRT1VFMinWLOvrHF2 )                                         )/     W &
                   - (      ( VFOvrHF      + VFOvrHF2     /SQRT1VFOvrHF2      )/( VFOvrHF      + SQRT1VFOvrHF2      ) &
                       -    ( VFMinWLOvrHF + VFMinWLOvrHF2/SQRT1VFMinWLOvrHF2 )/( VFMinWLOvrHF + SQRT1VFMinWLOvrHF2 )   )/     W &
                   + LOvrEA
            dXFdVF = (      ( 1.0_DbKi     + VFOvrHF      /SQRT1VFOvrHF2      )/( VFOvrHF      + SQRT1VFOvrHF2      ) &
                       -    ( 1.0_DbKi     + VFMinWLOvrHF /SQRT1VFMinWLOvrHF2 )/( VFMinWLOvrHF + SQRT1VFMinWLOvrHF2 )   )/     W
            dZFdHF = (                                     SQRT1VFOvrHF2                                              &
                       -                                   SQRT1VFMinWLOvrHF2                                           )/     W &
                   - (                       VFOvrHF2     /SQRT1VFOvrHF2                                              &
                       -                     VFMinWLOvrHF2/SQRT1VFMinWLOvrHF2                                           )/     W
            dZFdVF = (                       VFOvrHF      /SQRT1VFOvrHF2                                              &
                       -                     VFMinWLOvrHF /SQRT1VFMinWLOvrHF2                                           )/     W &
                   + LOvrEA


         ELSEIF (                                           -CB*VFMinWL <  HF         )  THEN   ! .TRUE. when a  portion of the line      rests on the seabed and the anchor tension is nonzero

            EXF    =     LOG( VFOvrHF      +               SQRT1VFOvrHF2      )                                          *HFOvrW &
                   - 0.5_DbKi*CBOvrEA*W*  LMinVFOvrW*LMinVFOvrW                                                                  &
                   + LOvrEA*  HF           + LMinVFOvrW  - XF
            EZF    = (                                     SQRT1VFOvrHF2                                   - 1.0_DbKi   )*HFOvrW &
                   + 0.5_DbKi*VF*VFOvrWEA                - ZF

            dXFdHF =     LOG( VFOvrHF      +               SQRT1VFOvrHF2      )                                          /     W &
                   - (      ( VFOvrHF      + VFOvrHF2     /SQRT1VFOvrHF2      )/( VFOvrHF      + SQRT1VFOvrHF2        ) )/     W &
                   + LOvrEA
            dXFdVF = (      ( 1.0_DbKi     + VFOvrHF      /SQRT1VFOvrHF2      )/( VFOvrHF      + SQRT1VFOvrHF2        ) )/     W &
                   + CBOvrEA*LMinVFOvrW - 1.0_DbKi/W
            dZFdHF = (                                     SQRT1VFOvrHF2                                   - 1.0_DbKi &
                       -                     VFOvrHF2     /SQRT1VFOvrHF2                                                )/     W
            dZFdVF = (                       VFOvrHF      /SQRT1VFOvrHF2                                                )/     W &
                   + VFOvrWEA


         ELSE                                                ! 0.0_DbKi <  HF  <= -CB*VFMinWL   !             A  portion of the line must rest  on the seabed and the anchor tension is    zero

            EXF    =     LOG( VFOvrHF      +               SQRT1VFOvrHF2      )                                          *HFOvrW &
                   - 0.5_DbKi*CBOvrEA*W*( LMinVFOvrW*LMinVFOvrW - ( LMinVFOvrW - HFOvrW/CB )*( LMinVFOvrW - HFOvrW/CB ) )        &
                   + LOvrEA*  HF           + LMinVFOvrW  - XF
            EZF    = (                                     SQRT1VFOvrHF2                                   - 1.0_DbKi   )*HFOvrW &
                   + 0.5_DbKi*VF*VFOvrWEA                - ZF

            dXFdHF =     LOG( VFOvrHF      +               SQRT1VFOvrHF2      )                                          /     W &
                   - (      ( VFOvrHF      + VFOvrHF2     /SQRT1VFOvrHF2      )/( VFOvrHF      + SQRT1VFOvrHF2      )   )/     W &
                   + LOvrEA - ( LMinVFOvrW - HFOvrW/CB )/EA
            dXFdVF = (      ( 1.0_DbKi     + VFOvrHF      /SQRT1VFOvrHF2      )/( VFOvrHF      + SQRT1VFOvrHF2      )   )/     W &
                   + HFOvrWEA           - 1.0_DbKi/W
            dZFdHF = (                                     SQRT1VFOvrHF2                                   - 1.0_DbKi &
                       -                     VFOvrHF2     /SQRT1VFOvrHF2                                                )/     W
            dZFdVF = (                       VFOvrHF      /SQRT1VFOvrHF2                                                )/     W &
                   + VFOvrWEA


         ENDIF


         ! Compute the determinant of the Jacobian matrix and the incremental
         !   tensions predicted by Newton-Raphson:

         DET = dXFdHF*dZFdVF - dXFdVF*dZFdHF

         dHF = ( -dZFdVF*EXF + dXFdVF*EZF )/DET    ! This is the incremental change in horizontal tension at the fairlead as predicted by Newton-Raphson
         dVF = (  dZFdHF*EXF - dXFdHF*EZF )/DET    ! This is the incremental change in vertical   tension at the fairlead as predicted by Newton-Raphson

         dHF = dHF*( 1.0_DbKi - Tol*I )            ! Reduce dHF by factor (between 1 at I = 1 and 0 at I = MaxIter) that reduces linearly with iteration count to ensure that we converge on a solution even in the case were we obtain a nonconvergent cycle about the correct solution (this happens, for example, if we jump to quickly between a taut and slack catenary)
         dVF = dVF*( 1.0_DbKi - Tol*I )            ! Reduce dHF by factor (between 1 at I = 1 and 0 at I = MaxIter) that reduces linearly with iteration count to ensure that we converge on a solution even in the case were we obtain a nonconvergent cycle about the correct solution (this happens, for example, if we jump to quickly between a taut and slack catenary)

         dHF = MAX( dHF, ( Tol - 1.0_DbKi )*HF )   ! To avoid an ill-conditioned situation, make sure HF does not go less than or equal to zero by having a lower limit of Tol*HF [NOTE: the value of dHF = ( Tol - 1.0_DbKi )*HF comes from: HF = HF + dHF = Tol*HF when dHF = ( Tol - 1.0_DbKi )*HF]


         ! Check if we have converged on a solution, or restart the iteration, or
         !   Abort if we cannot find a solution:

         IF ( ( ABS(dHF) <= ABS(Tol*HF) ) .AND. ( ABS(dVF) <= ABS(Tol*VF) ) )  THEN ! .TRUE. if we have converged; stop iterating! [The converge tolerance, Tol, is a fraction of tension]

            EXIT


         ELSEIF ( ( I == MaxIter )        .AND. (       FirstIter         ) )  THEN ! .TRUE. if we've iterated MaxIter-times for the first time;

         ! Perhaps we failed to converge because our initial guess was too far off.
         !   (This could happen, for example, while linearizing a model via large
         !   pertubations in the DOFs.)  Instead, use starting values documented in:
         !   Peyrot, Alain H. and Goulois, A. M., "Analysis Of Cable Structures,"
         !   Computers & Structures, Vol. 10, 1979, pp. 805-813:
         ! NOTE: We don't need to check if the current mooring line is exactly
         !       vertical (i.e., we don't need to check if XF == 0.0), because XF is
         !       limited by the tolerance above.

            XF2 = XF*XF
            ZF2 = ZF*ZF

            IF ( L <= SQRT( XF2 + ZF2 ) )  THEN ! .TRUE. if the current mooring line is taut
               Lamda0 = 0.2_DbKi
            ELSE                                ! The current mooring line must be slack and not vertical
               Lamda0 = SQRT( 3.0_DbKi*( ( L*L - ZF2 )/XF2 - 1.0_DbKi ) )
            ENDIF

            HF  = MAX( ABS( 0.5_DbKi*W*  XF/     Lamda0      ), Tol )   ! As above, set the lower limit of the guess value of HF to the tolerance
            VF  =           0.5_DbKi*W*( ZF/TANH(Lamda0) + L )


         ! Restart Newton-Raphson iteration:

            I         = 0
            FirstIter = .FALSE.
            dHF       = 0.0_DbKi
            dVF       = 0.0_DbKi


         ELSEIF ( ( I == MaxIter )        .AND. ( .NOT. FirstIter         ) )  THEN ! .TRUE. if we've iterated as much as we can take without finding a solution; Abort

            CALL ProgAbort ( ' Iteration not convergent. '// &
                         ' Routine Catenary() cannot solve quasi-static mooring line solution.' )


         ENDIF


         ! Increment fairlead tensions and iteration counter so we can try again:

         HF = HF + dHF
         VF = VF + dVF

         I  = I  + 1


      ENDDO



         ! We have found a solution for the tensions at the fairlead!

         ! Now compute the tensions at the anchor and the line position and tension
         !   at each node (again, these depend on the configuration of the mooring
         !   line):

      IF ( ( CB <  0.0_DbKi ) .OR. ( W  <  0.0_DbKi ) .OR. ( VFMinWL >  0.0_DbKi ) )  THEN   ! .TRUE. when no portion of the line      rests on the seabed

         ! Anchor tensions:

         HA = HF
         VA = VFMinWL


         ! Line position and tension at each node:

         DO I = 1,N  ! Loop through all nodes where the line position and tension are to be computed

!BJJ START of proposed change v7.00.01a-bjj
!bjj: line is too long
!rm            IF ( ( s(I) <  0.0_DbKi ) .OR. ( s(I) >  L ) )  &
!rm               CALL ProgAbort ( ' All line nodes must be located between the anchor and fairlead (inclusive) in routine Catenary().' )
            IF ( ( s(I) <  0.0_DbKi ) .OR. ( s(I) >  L ) )  THEN
               CALL ProgAbort ( ' All line nodes must be located between the anchor ' &
                              //'and fairlead (inclusive) in routine Catenary().' )
            END IF
!bjj end of proposed change            

            Ws                  = W       *s(I)                                  ! Initialize
            VFMinWLs            = VFMinWL + Ws                                   ! some commonly
            VFMinWLsOvrHF       = VFMinWLs/HF                                    ! used terms
            sOvrEA              = s(I)    /EA                                    ! that depend
            SQRT1VFMinWLsOvrHF2 = SQRT( 1.0_DbKi + VFMinWLsOvrHF*VFMinWLsOvrHF ) ! on s(I)

            X (I)    = (   LOG( VFMinWLsOvrHF + SQRT1VFMinWLsOvrHF2 ) &
                         - LOG( VFMinWLOvrHF  + SQRT1VFMinWLOvrHF2  )   )*HFOvrW                     &
                     + sOvrEA*  HF
            Z (I)    = (                        SQRT1VFMinWLsOvrHF2   &
                         -                      SQRT1VFMinWLOvrHF2      )*HFOvrW                     &
                     + sOvrEA*(         VFMinWL + 0.5_DbKi*Ws    )
            Te(I)    = SQRT( HF*HF +    VFMinWLs*VFMinWLs )

         ENDDO       ! I - All nodes where the line position and tension are to be computed


      ELSEIF (                                           -CB*VFMinWL <  HF         )  THEN   ! .TRUE. when a  portion of the line      rests on the seabed and the anchor tension is nonzero

         ! Anchor tensions:

         HA = HF + CB*VFMinWL
         VA = 0.0_DbKi


         ! Line position and tension at each node:

         DO I = 1,N  ! Loop through all nodes where the line position and tension are to be computed

!BJJ START of proposed change v7.00.01a-bjj
!bjj: line is too long
!rm            IF ( ( s(I) <  0.0_DbKi ) .OR. ( s(I) >  L ) )  &
!rm               CALL ProgAbort ( ' All line nodes must be located between the anchor and fairlead (inclusive) in routine Catenary().' )
            IF ( ( s(I) <  0.0_DbKi ) .OR. ( s(I) >  L ) )  THEN
               CALL ProgAbort ( ' All line nodes must be located between the anchor ' &
                              //'and fairlead (inclusive) in routine Catenary().' )
            END IF                              
!bjj end of proposed change

            Ws                  = W       *s(I)                                  ! Initialize
            VFMinWLs            = VFMinWL + Ws                                   ! some commonly
            VFMinWLsOvrHF       = VFMinWLs/HF                                    ! used terms
            sOvrEA              = s(I)    /EA                                    ! that depend
            SQRT1VFMinWLsOvrHF2 = SQRT( 1.0_DbKi + VFMinWLsOvrHF*VFMinWLsOvrHF ) ! on s(I)

            IF (     s(I) <= LMinVFOvrW             )  THEN ! .TRUE. if this node rests on the seabed and the tension is nonzero

               X (I) = s(I)                                                                          &
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: the s(I) in this line should not be here:
!remove6.02c                     + sOvrEA*( HF + CB*VFMinWL + 0.5_DbKi*Ws*CB ) + s(I)
                     + sOvrEA*( HF + CB*VFMinWL + 0.5_DbKi*Ws*CB )
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
               Z (I) = 0.0_DbKi
               Te(I) =       HF    + CB*VFMinWLs

            ELSE           ! LMinVFOvrW < s <= L            !           This node must be above the seabed

               X (I) =     LOG( VFMinWLsOvrHF + SQRT1VFMinWLsOvrHF2 )    *HFOvrW                     &
                     + sOvrEA*  HF + LMinVFOvrW                    - 0.5_DbKi*CB*VFMinWL*VFMinWL/WEA
               Z (I) = ( - 1.0_DbKi           + SQRT1VFMinWLsOvrHF2     )*HFOvrW                     &
                     + sOvrEA*(         VFMinWL + 0.5_DbKi*Ws    ) + 0.5_DbKi*   VFMinWL*VFMinWL/WEA
               Te(I) = SQRT( HF*HF +    VFMinWLs*VFMinWLs )

            ENDIF

         ENDDO       ! I - All nodes where the line position and tension are to be computed


      ELSE                                                ! 0.0_DbKi <  HF  <= -CB*VFMinWL   !             A  portion of the line must rest  on the seabed and the anchor tension is    zero

         ! Anchor tensions:

         HA = 0.0_DbKi
         VA = 0.0_DbKi


         ! Line position and tension at each node:

         DO I = 1,N  ! Loop through all nodes where the line position and tension are to be computed

!BJJ START of proposed change v7.00.01a-bjj
!bjj: line is too long
!RM            IF ( ( s(I) <  0.0_DbKi ) .OR. ( s(I) >  L ) )  &
!RM               CALL ProgAbort ( ' All line nodes must be located between the anchor and fairlead (inclusive) in routine Catenary().' )
            IF ( ( s(I) <  0.0_DbKi ) .OR. ( s(I) >  L ) )  THEN
               CALL ProgAbort ( ' All line nodes must be located between the anchor ' &
                              //'and fairlead (inclusive) in routine Catenary().' )
            END IF
!BJJ END OF PROPOSED CHANGE

            Ws                  = W       *s(I)                                  ! Initialize
            VFMinWLs            = VFMinWL + Ws                                   ! some commonly
            VFMinWLsOvrHF       = VFMinWLs/HF                                    ! used terms
            sOvrEA              = s(I)    /EA                                    ! that depend
            SQRT1VFMinWLsOvrHF2 = SQRT( 1.0_DbKi + VFMinWLsOvrHF*VFMinWLsOvrHF ) ! on s(I)

            IF (     s(I) <= LMinVFOvrW - HFOvrW/CB )  THEN ! .TRUE. if this node rests on the seabed and the tension is    zero

               X (I) = s(I)
               Z (I) = 0.0_DbKi
               Te(I) = 0.0_DbKi

            ELSEIF ( s(I) <= LMinVFOvrW             )  THEN ! .TRUE. if this node rests on the seabed and the tension is nonzero

               X (I) = s(I)                     - ( LMinVFOvrW - 0.5_DbKi*HFOvrW/CB )*HF/EA          &
                     + sOvrEA*( HF + CB*VFMinWL + 0.5_DbKi*Ws*CB ) + 0.5_DbKi*CB*VFMinWL*VFMinWL/WEA
               Z (I) = 0.0_DbKi
               Te(I) =       HF    + CB*VFMinWLs

            ELSE           ! LMinVFOvrW < s <= L            !           This node must be above the seabed

               X (I) =     LOG( VFMinWLsOvrHF + SQRT1VFMinWLsOvrHF2 )    *HFOvrW                     &
                     + sOvrEA*  HF + LMinVFOvrW - ( LMinVFOvrW - 0.5_DbKi*HFOvrW/CB )*HF/EA
               Z (I) = ( - 1.0_DbKi           + SQRT1VFMinWLsOvrHF2     )*HFOvrW                     &
                     + sOvrEA*(         VFMinWL + 0.5_DbKi*Ws    ) + 0.5_DbKi*   VFMinWL*VFMinWL/WEA
               Te(I) = SQRT( HF*HF +    VFMinWLs*VFMinWLs )

            ENDIF

         ENDDO       ! I - All nodes where the line position and tension are to be computed


      ENDIF



         ! The Newton-Raphson iteration is only accurate in double precision, so
         !   convert the output arguments back into the default precision for real
         !   numbers:

      HA_In    = REAL( HA   , ReKi )
      HF_In    = REAL( HF   , ReKi )
      Te_In(:) = REAL( Te(:), ReKi )
      VA_In    = REAL( VA   , ReKi )
      VF_In    = REAL( VF   , ReKi )
      X_In (:) = REAL( X (:), ReKi )
      Z_In (:) = REAL( Z (:), ReKi )



      RETURN
      END SUBROUTINE Catenary
!=======================================================================
!JASON: MOVE THIS USER-DEFINED ROUTINE (UserLine) TO THE UserSubs.f90 OF HydroDyn WHEN THE PLATFORM LOADING FUNCTIONALITY HAS BEEN DOCUMENTED!!!!!
      SUBROUTINE UserLine ( X       , ZTime    , DirRoot , F       , &
                            NumLines, LineNodes, FairHTen, FairVTen, &
                            AnchHTen, AnchVTen , Nodesxi , Nodesyi , &
                            Nodeszi , NodesTen                         )


         ! This is a dummy routine for holding the place of a user-specified
         ! mooring system.  Modify this code to create your own model of an
         ! array of mooring lines.  The local variables and associated
         ! calculations below provide a template for making this
         ! user-specified mooring system model include a linear 6x6 restoring
         ! matrix with offset.  These are provided as an example only and can
         ! be modified or deleted as desired by the user without detriment to
         ! the interface (i.e., they are not necessary for the interface).

         ! The primary output of this routine is array F(:), which must
         ! contain the 3 components of the total force from all mooring lines
         ! (in N) acting at the platform reference and the 3 components of the
         ! total moment from all mooring lines (in N-m) acting at the platform
         ! reference; positive forces are in the direction of positive
         ! platform displacement.  This primary output effects the overall
         ! dynamic response of the system.  However, this routine must also
         ! compute:
         !   Array FairHTen(:)   - Effective horizontal tension at the fairlead of each mooring line
         !   Array FairVTen(:)   - Effective vertical   tension at the fairlead of each mooring line
         !   Array AnchHTen(:)   - Effective horizontal tension at the anchor   of each mooring line
         !   Array AnchVTen(:)   - Effective vertical   tension at the anchor   of each mooring line
         !   Array NodesTen(:,:) - Effective line tensions              at each node of each line
         !   Array Nodesxi (:,:) - xi-coordinates in the inertial frame of each node of each line
         !   Array Nodesyi (:,:) - yi-coordinates in the inertial frame of each node of each line
         !   Array Nodeszi (:,:) - zi-coordinates in the inertial frame of each node of each line
         ! These secondary outputs are only used to determine what to output
         ! for the associated parameters placed in the OutList from the
         ! primary input file.  The number of mooring lines where the fairlead
         ! and anchor tensions can be output and the number of nodes per line
         ! where the mooring line position and tension can be output, NumLines
         ! and LineNodes, respectively, are additional inputs to this routine.


      USE                             Precision


      IMPLICIT                        NONE


         ! Passed Variables:

      INTEGER(4), INTENT(IN )      :: LineNodes                                       ! Number of nodes per line where the mooring line position and tension can be output, (-).
      INTEGER(4), INTENT(IN )      :: NumLines                                        ! Number of mooring lines where the fairlead and anchor tensions can be output, (-).

      REAL(ReKi), INTENT(OUT)      :: F        (6)                                    ! The 3 components of the total force from all mooring lines (in N) acting at the platform reference and the 3 components of the total moment from all mooring lines (in N-m) acting at the platform reference; positive forces are in the direction of positive platform displacement.
      REAL(ReKi), INTENT(OUT)      :: AnchHTen (NumLines          )                   ! Effective horizontal tension at the anchor   of each mooring line, N.
      REAL(ReKi), INTENT(OUT)      :: AnchVTen (NumLines          )                   ! Effective vertical   tension at the anchor   of each mooring line, N.
      REAL(ReKi), INTENT(OUT)      :: FairHTen (NumLines          )                   ! Effective horizontal tension at the fairlead of each mooring line, N.
      REAL(ReKi), INTENT(OUT)      :: FairVTen (NumLines          )                   ! Effective vertical   tension at the fairlead of each mooring line, N.
      REAL(ReKi), INTENT(OUT)      :: NodesTen (NumLines,LineNodes)                   ! Effective line tensions              at each node of each line, N.
      REAL(ReKi), INTENT(OUT)      :: Nodesxi  (NumLines,LineNodes)                   ! xi-coordinates in the inertial frame of each node of each line, meters.
      REAL(ReKi), INTENT(OUT)      :: Nodesyi  (NumLines,LineNodes)                   ! yi-coordinates in the inertial frame of each node of each line, meters.
      REAL(ReKi), INTENT(OUT)      :: Nodeszi  (NumLines,LineNodes)                   ! zi-coordinates in the inertial frame of each node of each line, meters.
      REAL(ReKi), INTENT(IN )      :: X        (6)                                    ! The 3 components of the translational displacement         (in m) of        the platform reference and the 3 components of the rotational displacement             (in rad) of        the platform relative to the inertial frame.
      REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time, sec.

      CHARACTER(1024), INTENT(IN ) :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.


         ! Local Variables:

      REAL(ReKi)                   :: F0       (6)                                    ! Total mooring line load acting on the support platform in its undisplaced position (N, N-m)
      REAL(ReKi)                   :: Stff     (6,6)                                  ! Linear restoring matrix from all mooring lines (kg/s^2, kg-m/s^2, kg-m^2/s^2)

      INTEGER(4)                   :: I                                               ! Generic index.
      INTEGER(4)                   :: J                                               ! Generic index.



      F0  (1  ) = 0.0
      F0  (2  ) = 0.0
      F0  (3  ) = 0.0
      F0  (4  ) = 0.0
      F0  (5  ) = 0.0
      F0  (6  ) = 0.0

      Stff(1,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
      Stff(2,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
      Stff(3,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
      Stff(4,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
      Stff(5,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
      Stff(6,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)

!JASON: VALUES FOR OldTLP; REMOVE THIS!!!F0  (1  ) =         0.0 !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!F0  (2  ) =         0.0 !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!F0  (3  ) = -41050000.0 !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!F0  (4  ) =         0.0 !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!F0  (5  ) =         0.0 !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!F0  (6  ) =         0.0 !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!Stff(1,:) = (/    907000.0,        0.0,         0.0,           0.0,   -16100000.0,        0.0 /)   !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!Stff(2,:) = (/         0.0,   907000.0,         0.0,    16100000.0,           0.0,        0.0 /)   !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!Stff(3,:) = (/         0.0,        0.0, 213000000.0,           0.0,           0.0,        0.0 /)   !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!Stff(4,:) = (/         0.0, 15600000.0,         0.0, 10600000000.0,           0.0,        0.0 /)   !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!Stff(5,:) = (/ -15600000.0,        0.0,         0.0,           0.0, 10600000000.0,        0.0 /)   !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
!JASON: VALUES FOR OldTLP; REMOVE THIS!!!Stff(6,:) = (/         0.0,        0.0,         0.0,           0.0,           0.0, 82900000.0 /)   !JASON: VALUES FOR OldTLP; REMOVE THIS!!!
F0  (1  ) = 0.0   !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
F0  (2  ) = 0.0   !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
F0  (3  ) = 0.0   !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
F0  (4  ) = 0.0   !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
F0  (5  ) = 0.0   !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
F0  (6  ) = 0.0   !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
Stff(1,:) = (/ 4000000.0,       0.0, 0.0, 0.0, 0.0, 0.0 /)  !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
Stff(2,:) = (/       0.0, 4000000.0, 0.0, 0.0, 0.0, 0.0 /)  !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
Stff(3,:) = (/       0.0,       0.0, 0.0, 0.0, 0.0, 0.0 /)  !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
Stff(4,:) = (/       0.0,       0.0, 0.0, 0.0, 0.0, 0.0 /)  !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
Stff(5,:) = (/       0.0,       0.0, 0.0, 0.0, 0.0, 0.0 /)  !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
Stff(6,:) = (/       0.0,       0.0, 0.0, 0.0, 0.0, 0.0 /)  !JASON: VALUES FOR MIT/NREL SDB; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!F0  (1  ) =         0.0 !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!F0  (2  ) =         0.0 !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!F0  (3  ) =  -6150000.0 !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!F0  (4  ) =         0.0 !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!F0  (5  ) =         0.0 !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!F0  (6  ) =         0.0 !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!Stff(1,:) = (/  15920.0,       0.0,     0.0,        0.0,   144700.0,       0.0 /)   !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!Stff(2,:) = (/      0.0,   15920.0,     0.0,  -144600.0,        0.0,       0.0 /)   !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!Stff(3,:) = (/      0.0,       0.0, 24930.0,        0.0,        0.0,       0.0 /)   !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!Stff(4,:) = (/      0.0, -144500.0,     0.0, 38740000.0,        0.0,       0.0 /)   !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!Stff(5,:) = (/ 144500.0,       0.0,     0.0,        0.0, 38740000.0,       0.0 /)   !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!
!JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!Stff(6,:) = (/      0.0,       0.0,     0.0,        0.0,        0.0, 2797000.0 /)   !JASON: VALUES FOR ITI BARGE; REMOVE THIS!!!

      DO I = 1,6     ! Loop through all mooring line forces and moments
            F(I) = F0(I)
         DO J = 1,6  ! Loop through all platform DOFs
            F(I) = F (I) - Stff(I,J)*X(J)
         ENDDO       ! J - All platform DOFs
      ENDDO          ! I - All mooring line forces and moments



      DO I = 1,NumLines       ! Loop through all mooring lines where the fairlead and anchor tensions can be output

         FairHTen   (I  ) = 0.0
         FairVTen   (I  ) = 0.0
         AnchHTen   (I  ) = 0.0
         AnchVTen   (I  ) = 0.0

         DO J = 1,LineNodes   ! Loop through all nodes per line where the line position and tension can be output

            Nodesxi (I,J) = 0.0
            Nodesyi (I,J) = 0.0
            Nodeszi (I,J) = 0.0
            NodesTen(I,J) = 0.0

         ENDDO                ! J - All nodes per line where the line position and tension can be output

      ENDDO                   ! I - All mooring lines where the fairlead and anchor tensions can be output



      RETURN
      END SUBROUTINE UserLine
!=======================================================================
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   END SUBROUTINE FltngPtfmLd
!=======================================================================
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!remove6.02b   SUBROUTINE InitFltngPtfmLd ( WAMITFile , PtfmVol0In, PtfmDiamIn, PtfmCDIn, &
!remove6.02b                                RdtnTMaxIn, RdtnDTIn                            )
   SUBROUTINE InitFltngPtfmLd ( WAMITFile  , PtfmVol0In, PtfmDiamIn , PtfmCDIn , &
                                RdtnTMaxIn , RdtnDTIn  , NumLinesIn , LineModIn, &
                                LAnchxiIn  , LAnchyiIn , LAnchziIn  , LFairxtIn, &
                                LFairytIn  , LFairztIn , LUnstrLenIn, LDiam    , &
                                LMassDen   , LEAStffIn , LSeabedCDIn, LTenTolIn, &
                                LineNodesIn, LSNodesIn , X0                        )
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.


      ! This routine is used to initialize the variables used in the time
      ! domain hydrodynamic loading and mooring system dynamics routines
      ! for various floating platform concepts.


   USE                             FFT_Module
!bjj start of proposed change v6.02d
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm   USE                             InterpSubs
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   USE                             Precision
!bjj end of proposed change
   USE                             Waves


   IMPLICIT                        NONE


      ! Passed Variables:

!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   INTEGER(4), INTENT(IN )      :: LineNodesIn                                     ! Number of nodes per line where the mooring line position and tension can be output (-)
   INTEGER(4), INTENT(IN )      :: NumLinesIn                                      ! Number of mooring lines (-)

   REAL(ReKi), INTENT(IN )      :: LAnchxiIn  (NumLinesIn)                         ! xi-coordinate of each anchor   in the inertial frame        coordinate system (meters)
   REAL(ReKi), INTENT(IN )      :: LAnchyiIn  (NumLinesIn)                         ! yi-coordinate of each anchor   in the inertial frame        coordinate system (meters)
   REAL(ReKi), INTENT(IN )      :: LAnchziIn  (NumLinesIn)                         ! zi-coordinate of each anchor   in the inertial frame        coordinate system (meters)
   REAL(ReKi), INTENT(IN )      :: LDiam      (NumLinesIn)                         ! Effective diameter of each mooring line for calculation of the line buoyancy (meters)
   REAL(ReKi), INTENT(IN )      :: LEAStffIn  (NumLinesIn)                         ! Extensional stiffness of each mooring line (N)
   REAL(ReKi), INTENT(IN )      :: LFairxtIn  (NumLinesIn)                         ! xt-coordinate of each fairlead in the tower base / platform coordinate system (meters)
   REAL(ReKi), INTENT(IN )      :: LFairytIn  (NumLinesIn)                         ! yt-coordinate of each fairlead in the tower base / platform coordinate system (meters)
   REAL(ReKi), INTENT(IN )      :: LFairztIn  (NumLinesIn)                         ! zt-coordinate of each fairlead in the tower base / platform coordinate system (meters)
   REAL(ReKi), INTENT(IN )      :: LMassDen   (NumLinesIn)                         ! Mass density of each mooring line (kg/m)
   REAL(ReKi), INTENT(IN )      :: LSeabedCDIn(NumLinesIn)                         ! Coefficient of seabed static friction drag of each mooring line (a negative value indicates no seabed) (-)
   REAL(ReKi), INTENT(IN )      :: LSNodesIn  (NumLinesIn,LineNodesIn)             ! Unstretched arc distance along mooring line from anchor to each node where the line position and tension can be output (meters)
   REAL(ReKi), INTENT(IN )      :: LTenTolIn  (NumLinesIn)                         ! Convergence tolerance within Newton-Raphson iteration of each mooring line specified as a fraction of tension (-)
   REAL(ReKi), INTENT(IN )      :: LUnstrLenIn(NumLinesIn)                         ! Unstretched length of each mooring line (meters)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   REAL(ReKi), INTENT(IN )      :: PtfmCDIn                                        ! Effective platform normalized hydrodynamic viscous drag coefficient in calculation of viscous drag term from Morison's equation (-)
   REAL(ReKi), INTENT(IN )      :: PtfmDiamIn                                      ! Effective platform diameter in calculation of viscous drag term from Morison's equation (meters)
   REAL(ReKi), INTENT(IN )      :: PtfmVol0In                                      ! Displaced volume of water when the platform is in its undisplaced position (m^3)
   REAL(ReKi), INTENT(IN )      :: RdtnDTIn                                        ! Time step for wave radiation kernel calculations (sec)
   REAL(ReKi), INTENT(IN )      :: RdtnTMaxIn                                      ! Analysis time for wave radiation kernel calculations; the actual analysis time may be larger than this value in order for the maintain an effecient (co)sine transform (sec)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi), INTENT(IN )      :: X0         (6)                                  ! The 3 components of the initial translational displacement (in m) of the platform reference and the 3 components of the initial rotational displacement (in rad) of the platform relative to the inertial frame

   INTEGER(4), INTENT(IN )      :: LineModIn                                       ! Mooring line model switch {0: none, 1: standard quasi-static, 2: user-defined from routine UserLine} (switch)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.

!bjj start of proposed change
!rm   CHARACTER(99), INTENT(IN )   :: WAMITFile                                       ! Root name of WAMIT output files containing the linear, nondimensionalized, hydrostatic restoring matrix (.hst extension), frequency-dependent hydrodynamic added mass matrix and damping matrix (.1 extension), and frequency- and direction-dependent wave excitation force vector per unit wave amplitude (.3 extension)
   CHARACTER(1024), INTENT(IN )   :: WAMITFile                                       ! Root name of WAMIT output files containing the linear, nondimensionalized, hydrostatic restoring matrix (.hst extension), frequency-dependent hydrodynamic added mass matrix and damping matrix (.1 extension), and frequency- and direction-dependent wave excitation force vector per unit wave amplitude (.3 extension)
!bjj end of proposed change


      ! Local Variables:

   COMPLEX(ReKi), ALLOCATABLE   :: HdroExctn (:,:,:)                               ! Frequency- and direction-dependent complex hydrodynamic wave excitation force per unit wave amplitude vector (kg/s^2, kg-m/s^2)
   COMPLEX(ReKi), ALLOCATABLE   :: WaveExctnC(:,:)                                 ! Fourier transform of the instantaneous value of the total excitation force on the support platfrom from incident waves (N-s, N-m-s)
   COMPLEX(ReKi), ALLOCATABLE   :: X_Diffrctn(:,:)                                 ! Frequency-dependent complex hydrodynamic wave excitation force per unit wave amplitude vector at the chosen wave heading direction, WaveDir (kg/s^2, kg-m/s^2)

!bjj rm not used:   REAL(ReKi)                   :: CHdroWvDir                                      ! COS( a given value of HdroWvDir )
   REAL(ReKi)                   :: DffrctDim (6)                                   ! Matrix used to redimensionalize WAMIT hydrodynamic wave excitation force  output (kg/s^2, kg-m/s^2            )
   REAL(ReKi), ALLOCATABLE      :: HdroAddMs (:,:)                                 ! The upper-triangular portion (diagonal and above) of the frequency-dependent hydrodynamic added mass matrix from the radiation problem (kg  , kg-m  , kg-m^2  )
   REAL(ReKi), ALLOCATABLE      :: HdroDmpng (:,:)                                 ! The upper-triangular portion (diagonal and above) of the frequency-dependent hydrodynamic damping    matrix from the radiation problem (kg/s, kg-m/s, kg-m^2/s)
   REAL(ReKi), ALLOCATABLE      :: HdroFreq  (:)                                   ! Frequency components inherent in the hydrodynamic added mass matrix, hydrodynamic daming matrix, and complex wave excitation force per unit wave amplitude vector (rad/s)
   REAL(ReKi), ALLOCATABLE      :: HdroWvDir (:)                                   ! Incident wave propagation heading direction components inherent in the complex wave excitation force per unit wave amplitude vector (degrees)
   REAL(ReKi)                   :: HighFreq    = 0.0                               ! The highest frequency component in the WAMIT file, not counting infinity.
   REAL(ReKi)                   :: Krnl_Fact                                       ! Factor used to scale the magnitude of the RdtnKnrl  as required by the discrete time (co)sine transform (-)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi)                   :: Lamda0                                          ! Catenary parameter used to generate the initial guesses of the horizontal and vertical tensions at the fairlead for the Newton-Raphson iteration (-)
   REAL(ReKi)                   :: LFairxi                                         ! xi-coordinate of the current fairlead in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairyi                                         ! yi-coordinate of the current fairlead in the inertial frame coordinate system (meters)
   REAL(ReKi)                   :: LFairzi                                         ! zi-coordinate of the current fairlead in the inertial frame coordinate system (meters)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   REAL(ReKi)                   :: Omega                                           ! Wave frequency (rad/s)
   REAL(ReKi), PARAMETER        :: OnePlusEps  = 1.0 + EPSILON(OnePlusEps)         ! The number slighty greater than unity in the precision of ReKi.
   REAL(ReKi)                   :: PrvDir                                          ! The value of TmpDir from the previous line (degrees)
   REAL(ReKi)                   :: PrvPer                                          ! The value of TmpPer from the previous line (sec    )
   REAL(ReKi), PARAMETER        :: PtfmULEN    = 1.0                               ! Characteristic body length scale used to redimensionalize WAMIT output (meters) !JASON: BECAUSE I HAVE FIXED THIS TO UNITY, THE WAMIT .GDF FILE MUST HAVE ULEN SET TO 1.0.  SHOULD WE INSTEAD MAKE PtfmULEN AN ACTUAL INPUT TO THE PROGRAM WITHIN PtfmFile???
   REAL(ReKi)                   :: RdtnDim   (6,6)                                 ! Matrix used to redimensionalize WAMIT hydrodynamic added mass and damping output (kg    , kg-m    , kg-m^2    )
   REAL(ReKi)                   :: RdtnDOmega                                      ! Frequency step for wave radiation kernel calculations (rad/s)
   REAL(ReKi)                   :: RdtnOmegaMax                                    ! Maximum frequency used in the (co)sine transform to fine the radiation impulse response functions (rad/s)
   REAL(ReKi), ALLOCATABLE      :: RdtnTime  (:)                                   ! Simulation times at which the instantaneous values of the wave radiation kernel are determined (sec)
!bjj rm not used:   REAL(ReKi)                   :: SHdroWvDir                                      ! SIN( a given value of HdroWvDir )
   REAL(ReKi)                   :: SttcDim   (6,6)                                 ! Matrix used to redimensionalize WAMIT hydrostatic  restoring              output (kg/s^2, kg-m/s^2, kg-m^2/s^2)
   REAL(ReKi)                   :: TmpData1                                        ! A temporary           value  read in from a WAMIT file (-      )
   REAL(ReKi)                   :: TmpData2                                        ! A temporary           value  read in from a WAMIT file (-      )
   REAL(ReKi)                   :: TmpDir                                          ! A temporary direction        read in from a WAMIT file (degrees)
   REAL(ReKi)                   :: TmpIm                                           ! A temporary imaginary value  read in from a WAMIT file (-      ) - stored as a REAL value
   REAL(ReKi)                   :: TmpPer                                          ! A temporary period           read in from a WAMIT file (sec    )
   REAL(ReKi)                   :: TmpRe                                           ! A temporary real      value  read in from a WAMIT file (-      )
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi)                   :: TransMat0 (3,3)                                 ! Transformation matrix from the inertial frame to the initial tower base / platform coordinate system (-)
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   REAL(ReKi), ALLOCATABLE      :: WAMITFreq (:)                                   ! Frequency      components as ordered in the WAMIT output files (rad/s  )
   REAL(ReKi), ALLOCATABLE      :: WAMITPer  (:)                                   ! Period         components as ordered in the WAMIT output files (sec    )
   REAL(ReKi), ALLOCATABLE      :: WAMITWvDir(:)                                   ! Wave direction components as ordered in the WAMIT output files (degrees)
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
   REAL(ReKi)                   :: XF                                              ! Horizontal distance between anchor and fairlead of the current mooring line (meters)
   REAL(ReKi)                   :: XF2                                             ! = XF*XF
   REAL(ReKi)                   :: ZF                                              ! Vertical   distance between anchor and fairlead of the current mooring line (meters)
   REAL(ReKi)                   :: ZF2                                             ! = ZF*ZF
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.

   INTEGER(4)                   :: I                                               ! Generic index
   INTEGER(4)                   :: Indx                                            ! Cycles through the upper-triangular portion (diagonal and above) of the frequency-dependent hydrodynamic added mass and damping matrices from the radiation problem
   INTEGER(4)                   :: InsertInd                                       ! The lowest sorted index whose associated frequency component is higher than the current frequency component -- this is to sort the frequency components from lowest to highest
   INTEGER(4)                   :: J                                               ! Generic index
   INTEGER(4)                   :: K                                               ! Generic index
   INTEGER(4)                   :: LastInd     = 1                                 ! Index into the arrays saved from the last call as a starting point for this call
   INTEGER(4)                   :: NInpFreq                                        ! Number of input frequency components inherent in the hydrodynamic added mass matrix, hydrodynamic daming matrix, and complex wave excitation force per unit wave amplitude vector (-)
   INTEGER(4)                   :: NInpWvDir                                       ! Number of input incident wave propagation heading direction components inherent in the complex wave excitation force per unit wave amplitude vector (-)
   INTEGER(4)                   :: NStepRdtn2                                      ! ( NStepRdtn-1 )/2
   INTEGER(4), ALLOCATABLE      :: SortFreqInd (:)                                 ! The array of indices such that WAMITFreq (SortFreqInd (:)) is sorted from lowest to highest frequency (-)
   INTEGER(4), ALLOCATABLE      :: SortWvDirInd(:)                                 ! The array of indices such that WAMITWvDir(SortWvDirInd(:)) is sorted from lowest to highest agnle     (-)
   INTEGER(4)                   :: Sttus                                           ! Status returned by an attempted allocation or READ.
   INTEGER(4)                   :: UnW1        = 31                                ! I/O unit number for the WAMIT output file with the .1   extension; this file contains the linear, nondimensionalized, frequency-dependent solution to the radiation   problem.
   INTEGER(4)                   :: UnW3        = 32                                ! I/O unit number for the WAMIT output file with the .3   extension; this file contains the linear, nondimensionalized, frequency-dependent solution to the diffraction problem.
   INTEGER(4)                   :: UnWh        = 33                                ! I/O unit number for the WAMIT output file with the .hst extension; this file contains the linear, nondimensionalized hydrostatic restoring matrix.

   LOGICAL                      :: FirstFreq                                       ! When .TRUE., indicates we're still looping through the first frequency component.
   LOGICAL                      :: FirstPass                                       ! When .TRUE., indicates we're on the first pass through a loop.
   LOGICAL                      :: InfFreq     = .FALSE.                           ! When .TRUE., indicates that the infinite-frequency limit of added mass is contained within the WAMIT output files.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
   LOGICAL                      :: NewPer                                          ! When .TRUE., indicates that the period has just changed.
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   LOGICAL                      :: RdtnFrmAM   = .FALSE.                           ! Determine the wave radiation kernel from the frequency-dependent hydrodynamic added mass matrix? (.TRUE = yes, .FALSE. = determine the wave radiation kernel from the frequency-dependent hydrodynamic damping matrix) !JASON: SHOULD YOU MAKE THIS AN INPUT???<--JASON: IT IS NOT WISE TO COMPUTE THE RADIATION KERNEL FROM THE FREQUENCY-DEPENDENT ADDED MASS MATRIX, UNLESS A CORRECTION IS APPLIED.  THIS IS DESCRIBED IN THE WAMIT USER'S GUIDE!!!!
   LOGICAL                      :: ZeroFreq    = .FALSE.                           ! When .TRUE., indicates that the zero    -frequency limit of added mass is contained within the WAMIT output files.

!bjj start of proposed change
!rm   CHARACTER(99)                :: Line                                            ! String to temporarily hold the value of a line within a WAMIT output file.
   CHARACTER(1024)                :: Line                                            ! String to temporarily hold the value of a line within a WAMIT output file.
!bjj end of proposed change   

!bjj start of proposed change v6.02d
!rm      ! Global functions:
!rm
!rm!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm!jmj Move SUBROUTINEs InterpStp() and InterpStp_CMPLX() into a MODULE at the
!rm!jmj   top of source file HydroCalc.f90 in support of improved code
!rm!jmj   optimization:
!rm!remove6.02c   COMPLEX(ReKi), EXTERNAL      :: InterpStp_CMPLX                                 ! A generic function to do the actual interpolation.
!rm!remove6.02c
!rm!remove6.02c   REAL(ReKi), EXTERNAL         :: InterpStp                                       ! A generic function to do the actual interpolation.
!rm!remove6.02c
!rm!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
!rm   CHARACTER(15), EXTERNAL      :: Flt2LStr                                        ! A function to convert a real to a left-justified string.
!bjj end of proposed change



      ! Save these values for future use:

   PtfmVol0     = PtfmVol0In
   PtfmDiam     = PtfmDiamIn
   PtfmCD       = PtfmCDIn
   RdtnDT       = RdtnDTIn
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Put in some logic to ensure that the hydrodynamic loads are time invariant
!jmj   when linearizing a model:
!remove6.02b   RdtnTMax     = RdtnTMaxIn
   IF ( RdtnTMaxIn == 0.0 )  THEN   ! .TRUE. when we don't want to model wave radiation damping; set RdtnTMax to some minimum value greater than zero to avoid an error in the calculations below.
      RdtnTMax  = RdtnDTIn
      UseRdtn   = .FALSE.
   ELSE                             ! We will be modeling wave radiation damping.
      RdtnTMax  = RdtnTMaxIn
      UseRdtn   = .TRUE.
   ENDIF
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.

   RdtnOmegaMax = Pi/RdtnDT




      ! ProgAbort if the wave elevation has not been computed yet:

   IF ( .NOT. ALLOCATED ( WaveElev ) )  &
      CALL ProgAbort ( ' Routine InitWaves() must be called before routine InitFltngPtfmLd().' )




!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
      ! Initialize the variables associated with the mooring system:

   LineMod      = LineModIn
   LineNodes    = LineNodesIn
   NumLines     = NumLinesIn

   ALLOCATE ( LAnchHTe (NumLines            ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort ( ' Error allocating memory for the LAnchHTe array.' )
   ENDIF

   ALLOCATE ( LAnchVTe (NumLines            ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort ( ' Error allocating memory for the LAnchVTe array.' )
   ENDIF

   ALLOCATE ( LFairHTe (NumLines            ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort ( ' Error allocating memory for the LFairHTe array.' )
   ENDIF

   ALLOCATE ( LFairVTe (NumLines            ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort ( ' Error allocating memory for the LFairVTe array.' )
   ENDIF

   ALLOCATE ( LNodesPi (NumLines,LineNodes,3) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort ( ' Error allocating memory for the LNodesPi array.' )
   ENDIF

   ALLOCATE ( LNodesTe (NumLines,LineNodes  ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort ( ' Error allocating memory for the LNodesTe array.' )
   ENDIF

   LAnchHTe(:    ) = 0.0
   LAnchVTe(:    ) = 0.0
   LFairHTe(:    ) = 0.0
   LFairVTe(:    ) = 0.0
   LNodesPi(:,:,:) = 0.0
   LNodesTe(:,:  ) = 0.0

   IF ( LineMod == 1 )  THEN  ! .TRUE if we have standard quasi-static mooring lines.

      ALLOCATE ( LAnchxi  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LAnchxi array.' )
      ENDIF

      ALLOCATE ( LAnchyi  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LAnchyi array.' )
      ENDIF

      ALLOCATE ( LAnchzi  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LAnchzi array.' )
      ENDIF

      ALLOCATE ( LFairxt  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LFairxt array.' )
      ENDIF

      ALLOCATE ( LFairyt  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LFairyt array.' )
      ENDIF

      ALLOCATE ( LFairzt  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LFairzt array.' )
      ENDIF

      ALLOCATE ( LUnstrLen(NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LUnstrLen array.' )
      ENDIF

      ALLOCATE ( LEAStff  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LEAStff array.' )
      ENDIF

      ALLOCATE ( LSeabedCD(NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LSeabedCD array.' )
      ENDIF

      ALLOCATE ( LTenTol  (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LTenTol array.' )
      ENDIF

      ALLOCATE ( LFldWght (NumLines          ) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LFldWght array.' )
      ENDIF

      ALLOCATE ( LSNodes  (NumLines,LineNodes) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LSNodes array.' )
      ENDIF

      ALLOCATE ( LNodesX  (         LineNodes) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LNodesX array.' )
      ENDIF

      ALLOCATE ( LNodesZ  (         LineNodes) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort ( ' Error allocating memory for the LNodesZ array.' )
      ENDIF

      LAnchxi  (:  ) = LAnchxiIn  (:  )
      LAnchyi  (:  ) = LAnchyiIn  (:  )
      LAnchzi  (:  ) = LAnchziIn  (:  )
      LFairxt  (:  ) = LFairxtIn  (:  )
      LFairyt  (:  ) = LFairytIn  (:  )
      LFairzt  (:  ) = LFairztIn  (:  )
      LUnstrLen(:  ) = LUnstrLenIn(:  )
      LEAStff  (:  ) = LEAStffIn  (:  )
      LSeabedCD(:  ) = LSeabedCDIn(:  )
      LTenTol  (:  ) = LTenTolIn  (:  )
      LSNodes  (:,:) = LSNodesIn  (:,:)


      ! Get the transformation matrix, TransMat0, from the inertial frame to the
      !   initial tower base / platform coordinate system:

      CALL SmllRotTrans ( 'platform displacement', X0(4), X0(5), X0(6), TransMat0 )


      DO I = 1,NumLines ! Loop through all mooring lines


      ! Compute the weight of each mooring line in fluid per unit length based on
      !   their mass density and effective diameter, water density, and gravity:
      ! NOTE: The buoyancy is calculated assuming that the entire length of the
      !       mooring line is submerged in the water.

         LFldWght(I) = ( LMassDen(I) - WtrDens*PiOvr4*LDiam(I)*LDiam(I) )*Gravity


      ! Transform the fairlead location from the initial platform to the inertial
      !    frame coordinate system:
      ! NOTE: TransMat0^T = TransMat0^-1 where ^T = matrix transpose and ^-1 =
      !       matrix inverse.

         LFairxi = X0(1) + TransMat0(1,1)*LFairxt(I) + TransMat0(2,1)*LFairyt(I) + TransMat0(3,1)*LFairzt(I)
         LFairyi = X0(2) + TransMat0(1,2)*LFairxt(I) + TransMat0(2,2)*LFairyt(I) + TransMat0(3,2)*LFairzt(I)
         LFairzi = X0(3) + TransMat0(1,3)*LFairxt(I) + TransMat0(2,3)*LFairyt(I) + TransMat0(3,3)*LFairzt(I)


      ! Transform the fairlead location from the inertial frame coordinate system
      !   to the local coordinate system of the current line (this coordinate
      !   system lies at the current anchor, Z being vertical, and X directed from
      !   the current anchor to the current fairlead):

         XF      = SQRT( ( LFairxi - LAnchxi(I) )**2.0 + ( LFairyi - LAnchyi(I) )**2.0 )
         ZF      =         LFairzi - LAnchzi(I)

         XF2     = XF*XF
         ZF2     = ZF*ZF


      ! Generate the initial guess values for the horizontal and vertical tensions
      !   at the fairlead in the Newton-Raphson iteration for the catenary mooring
      !   line solution.  Use starting values documented in: Peyrot, Alain H. and
      !   Goulois, A. M., "Analysis Of Cable Structures," Computers & Structures,
      !   Vol. 10, 1979, pp. 805-813:

         IF     ( XF           == 0.0               )  THEN ! .TRUE. if the current mooring line is exactly vertical
            Lamda0 = 1.0E+06
         ELSEIF ( LUnstrLen(I) <= SQRT( XF2 + ZF2 ) )  THEN ! .TRUE. if the current mooring line is taut
            Lamda0 = 0.2
         ELSE                                               ! The current mooring line must be slack and not vertical
            Lamda0 = SQRT( 3.0*( ( LUnstrLen(I)*LUnstrLen(I) - ZF2 )/XF2 - 1.0 ) )
         ENDIF

         LFairHTe(I) = ABS( 0.5*LFldWght(I)*  XF/     Lamda0                   )
         LFairVTe(I) =      0.5*LFldWght(I)*( ZF/TANH(Lamda0) + LUnstrLen(I) )


      ENDDO             ! I - All mooring lines

   ENDIF




!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
      ! Tell our nice users what is about to happen that may take a while:

   CALL WrScr ( ' Reading in WAMIT output with root name "'//TRIM(WAMITFile)//'".' )



      ! Let's set up the matrices used to redimensionalize the hydrodynamic data
      !   from WAMIT; all these matrices are symmetric and need to be used with
      !   element-by-element multiplication, instead of matrix-by-matrix
      !   multiplication:

   SttcDim(1,1) = RhoXg  *PtfmULEN**2  ! Force-translation
   SttcDim(1,4) = RhoXg  *PtfmULEN**3  ! Force-rotation/Moment-translation - Hydrostatic restoring
   SttcDim(4,4) = RhoXg  *PtfmULEN**4  ! Moment-rotation

   RdtnDim(1,1) = WtrDens*PtfmULEN**3  ! Force-translation
   RdtnDim(1,4) = WtrDens*PtfmULEN**4  ! Force-rotation/Moment-translation - Hydrodynamic added mass and damping
   RdtnDim(4,4) = WtrDens*PtfmULEN**5  ! Moment-rotation

   DffrctDim(1) = RhoXg  *PtfmULEN**2  ! Force-translation - Hydrodynamic wave excitation force
   DffrctDim(4) = RhoXg  *PtfmULEN**3  ! Moment-rotation

   DO I = 1,3     ! Loop through all force-translation elements (rows)

      DO J = 1,3  ! Loop through all force-translation elements (columns)

         SttcDim(I,J) = SttcDim(1,1)

         RdtnDim(I,J) = RdtnDim(1,1)

      ENDDO       ! J - All force-translation elements (columns)

      DffrctDim (I  ) = DffrctDim(1)

   ENDDO          ! I - All force-translation elements (rows)

   DO I = 1,3     ! Loop through all force-rotation/moment-translation elements (rows/columns)

      DO J = 4,6  ! Loop through all force-rotation/moment-translation elements (columns/rows)

         SttcDim(I,J) = SttcDim(1,4)
         SttcDim(J,I) = SttcDim(1,4)

         RdtnDim(I,J) = RdtnDim(1,4)
         RdtnDim(J,I) = RdtnDim(1,4)

      ENDDO       ! J - All force-rotation/moment-translation elements (rows/columns)

   ENDDO          ! I - All force-rotation/moment-translation elements (columns/rows)

   DO I = 4,6     ! Loop through all moment-rotation elements (rows)

      DO J = 4,6  ! Loop through all moment-rotation elements (columns)

         SttcDim(I,J) = SttcDim(4,4)

         RdtnDim(I,J) = RdtnDim(4,4)

      ENDDO       ! J - All moment-rotation elements (columns)

      DffrctDim (I  ) = DffrctDim(4)

   ENDDO          ! I - All moment-rotation elements (rows)




      ! Let's read in and redimensionalize the hydrodynamic data from the WAMIT
      !   output files:



      ! Linear restoring from the hydrostatics problem:

   CALL OpenFInpFile ( UnWh, TRIM(WAMITFile)//'.hst' )  ! Open file.

   HdroSttc (:,:) = 0.0 ! Initialize to zero

   DO    ! Loop through all rows in the file


      READ (UnWh,*,IOSTAT=Sttus)  I, J, TmpData1   ! Read in the row index, column index, and nondimensional data from the WAMIT file

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully

         HdroSttc (I,J) = TmpData1*SttcDim(I,J)    ! Redimensionalize the data and place it at the appropriate location within the array

      ELSE                    ! We must have reached the end of the file, so stop reading in data

         EXIT

      ENDIF


   ENDDO ! End loop through all rows in the file

   CLOSE ( UnWh ) ! Close file.



      ! Linear, frequency-dependent hydrodynamic added mass and damping from the
      !   radiation problem:

   CALL OpenFInpFile ( UnW1, TRIM(WAMITFile)//'.1'   )  ! Open file.


      ! First find the number of input frequency components inherent in the
      !   hydrodynamic added mass matrix, hydrodynamic daming matrix, and complex
      !   wave excitation force per unit wave amplitude vector:

   NInpFreq  = 0        ! Initialize to zero
   PrvPer    = 0.0      ! Initialize to a don't care
   FirstPass = .TRUE.   ! Initialize to .TRUE. for the first pass

   DO    ! Loop through all rows in the file


      READ (UnW1,*,IOSTAT=Sttus)  TmpPer  ! Read in only the period from the WAMIT file

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully

         IF ( FirstPass .OR. ( TmpPer /= PrvPer ) )  THEN   ! .TRUE. if we are on the first pass or if the period currently read in is different than the previous period read in; thus we found a new frequency in the WAMIT file!
            NInpFreq  = NInpFreq + 1      ! Since we found a new frequency, count it in the total
            PrvPer    = TmpPer            ! Store the current period as the previous period for the next pass
            FirstPass = .FALSE.           ! Sorry, you can only have one first pass
         ENDIF

      ELSE                    ! We must have reached the end of the file, so stop reading in data

         EXIT

      ENDIF


   ENDDO ! End loop through all rows in the file


   REWIND (UNIT=UnW1)   ! REWIND the file so we can read it in a second time.


   ! Now that we know how many frequencies there are, we can ALLOCATE the arrays
   !   to store the frequencies and frequency-dependent hydrodynamic added mass
   !   and damping matrices:

   ALLOCATE ( WAMITFreq  (NInpFreq   ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the WAMITFreq array.')
   ENDIF

   ALLOCATE ( WAMITPer   (NInpFreq   ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the WAMITPer array.')
   ENDIF

   ALLOCATE ( SortFreqInd(NInpFreq   ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the SortFreqInd array.')
   ENDIF

   ALLOCATE ( HdroFreq   (NInpFreq   ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the HdroFreq array.')
   ENDIF

   ALLOCATE ( HdroAddMs  (NInpFreq,21) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the HdroAddMs array.')
   ENDIF

   ALLOCATE ( HdroDmpng  (NInpFreq,21) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the HdroDmpng array.')
   ENDIF


      ! Now find out how the frequencies are ordered in the file.  When we read in
      !   the added mass and damping matrices, we need to have them sorted by
      !   increasing frequency.  Thus, find the array of indices, SortFreqInd(),
      !   such that WAMITFreq(SortFreqInd(:)) is sorted from lowest to highest
      !   frequency:

   K         = 0        ! Initialize to zero
   PrvPer    = 0.0      ! Initialize to a don't care
   FirstPass = .TRUE.   ! Initialize to .TRUE. for the first pass

   DO    ! Loop through all rows in the file


      READ (UnW1,*,IOSTAT=Sttus)  TmpPer  ! Read in only the period from the WAMIT file

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully

         IF ( FirstPass .OR. ( TmpPer /= PrvPer ) )  THEN   ! .TRUE. if we are on the first pass or if the period currently read in is different than the previous period read in; thus we found a new frequency in the WAMIT file!

            K               = K + 1       ! This is current count of which frequency component we are on
            PrvPer          = TmpPer      ! Store the current period as the previous period for the next pass
            FirstPass       = .FALSE.     ! Sorry, you can only have one first pass

            WAMITPer    (K) = TmpPer         ! Store the periods                         in the order they appear in the WAMIT file
            IF (     TmpPer <  0.0 )  THEN   ! Periods less than zero in WAMIT represent infinite period = zero frequency
               WAMITFreq(K) = 0.0
               ZeroFreq     = .TRUE.
            ELSEIF ( TmpPer == 0.0 )  THEN   ! Periods equal to  zero in WAMIT represent infinite frequency
               WAMITFreq(K) = HUGE(TmpPer)   ! Use HUGE() to approximate infinity in the precision of ReKi
               InfFreq      = .TRUE.
            ELSE                             ! We must have positive, non-infinite frequency
               WAMITFreq(K) = TwoPi/TmpPer   ! Store the periods as frequencies in rad/s in the order they appear in the WAMIT file
               HighFreq     = MAX( HighFreq, WAMITFreq(K) ) ! Find the highest frequency (HighFreq) in the WAMIT output file, not counting infinity (even if the infinite frequency limit is in the file).
            ENDIF

            InsertInd       = K           ! Initialize as the K'th component
            DO I = 1,K-1   ! Loop throuh all previous frequencies
               IF ( ( WAMITFreq(I) > WAMITFreq(K) ) )  THEN ! .TRUE. if a previous frequency component is higher than the current frequency component
                  InsertInd      = MIN( InsertInd, SortFreqInd(I) )  ! Store the lowest sorted index whose associated frequency component is higher than the current frequency component
                  SortFreqInd(I) = SortFreqInd(I) + 1                ! Shift all of the sorted indices up by 1 whose associated frequency component is higher than the current frequency component
               ENDIF
            ENDDO          ! I - All previous frequencies
            SortFreqInd(K)  = InsertInd   ! Store the index such that WAMITFreq(SortFreqInd(:)) is sorted from lowest to highest frequency

         ENDIF

      ELSE                    ! We must have reached the end of the file, so stop reading in data

         EXIT

      ENDIF


   ENDDO ! End loop through all rows in the file


   REWIND (UNIT=UnW1)   ! REWIND the file so we can read it in a third time.  (This is getting ridiculous!)


      ! Now we can finally read in the frequency-dependent added mass and damping
      !   matrices; only store the upper-triangular portions (diagonal and above)
      !   of these matrices:

   K              = 0      ! Initialize to zero
   PrvPer         = 0.0    ! Initialize to a don't care
   FirstPass      = .TRUE. ! Initialize to .TRUE. for the first pass

   HdroAddMs(:,:) = 0.0    ! Initialize to zero
   HdroDmpng(:,:) = 0.0    ! Initialize to zero

   DO    ! Loop through all rows in the file


      READ (UnW1,'(A)',IOSTAT=Sttus)  Line   ! Read in the entire line

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully


         READ (Line,*)  TmpPer               ! Read in only the period from the WAMIT file


         IF ( FirstPass .OR. ( TmpPer /= PrvPer ) )  THEN   ! .TRUE. if we are on the first pass or if the period currently read in is different than the previous period read in; thus we found a new frequency in the WAMIT file!

            K              = K + 1           ! This is current count of which frequency component we are on
            PrvPer         = TmpPer          ! Store the current period as the previous period for the next pass
            FirstPass      = .FALSE.         ! Sorry, you can only have one first pass

            IF (     TmpPer <  0.0 )  THEN   ! Periods less than zero in WAMIT represent infinite period = zero frequency
               HdroFreq (SortFreqInd(K)) = 0.0
            ELSEIF ( TmpPer == 0.0 )  THEN   ! Periods equal to  zero in WAMIT represent infinite frequency; a value slightly larger than HighFreq is returned to approximate infinity while still maintaining an effective interpolation later on.
               HdroFreq (SortFreqInd(K)) = HighFreq*OnePlusEps ! Set the infinite frequency to a value slightly larger than HighFreq
            ELSE                             ! We must have positive, non-infinite frequency
               HdroFreq (SortFreqInd(K)) = TwoPi/TmpPer  ! Convert the period in seconds to a frequency in rad/s and store them sorted from lowest to highest
            ENDIF

         ENDIF


         IF ( TmpPer <= 0.0 )  THEN          ! .TRUE. if the current period is less than or equal to zero, which in WAMIT represents the zero and infinite frequency limits, respectively; in these cases, only the added mass matrix is computed and output by WAMIT (and based on hydrodynamic theory, the damping matrix is zero as initialized above)

            READ (Line,*)  TmpPer, I, J, TmpData1           ! Read in the period, row index, column index, and nondimensional data from the WAMIT file

            IF ( J >= I )  THEN  ! .TRUE. if we are on or above the diagonal
               Indx = 6*( I - 1 ) + J - ( I*( I - 1 ) )/2                                       ! Convert from row/column indices to an index in the format used to save only the upper-triangular portion of the matrix.  NOTE: ( I*( I - 1 ) )/2 = SUM(I,START=1,END=I-1).

               HdroAddMs(SortFreqInd(K),Indx) = TmpData1*RdtnDim(I,J)                           ! Redimensionalize the data and place it at the appropriate location within the array
            ENDIF

         ELSE                                ! We must have a positive, non-infinite frequency.

            READ (Line,*)  TmpPer, I, J, TmpData1, TmpData2 ! Read in the period, row index, column index, and nondimensional data from the WAMIT file

            IF ( J >= I )  THEN  ! .TRUE. if we are on or above the diagonal
               Indx = 6*( I - 1 ) + J - ( I*( I - 1 ) )/2                                       ! Convert from row/column indices to an index in the format used to save only the upper-triangular portion of the matrix.  NOTE: ( I*( I - 1 ) )/2 = SUM(I,START=1,END=I-1).

               HdroAddMs(SortFreqInd(K),Indx) = TmpData1*RdtnDim(I,J)                           ! Redimensionalize the data and place it at the appropriate location within the array
               HdroDmpng(SortFreqInd(K),Indx) = TmpData2*RdtnDim(I,J)*HdroFreq(SortFreqInd(K))  ! Redimensionalize the data and place it at the appropriate location within the array
            ENDIF

         ENDIF


      ELSE                    ! We must have reached the end of the file, so stop reading in data


         EXIT


      ENDIF


   ENDDO ! End loop through all rows in the file


   CLOSE ( UnW1 ) ! Close file.



      ! Linear, frequency- and direction-dependent complex hydrodynamic wave
      !   excitation force per unit wave amplitude vector from the diffraction
      !   problem:

   CALL OpenFInpFile ( UnW3, TRIM(WAMITFile)//'.3'   )  ! Open file.


      ! First find the number of input incident wave propagation heading direction
      !   components inherent in the complex wave excitation force per unit wave
      !   amplitude vector:

   NInpWvDir = 0        ! Initialize to zero
   PrvDir    = 0.0      ! Initialize to a don't care
   FirstPass = .TRUE.   ! Initialize to .TRUE. for the first pass

   DO    ! Loop through all rows in the file


      READ (UnW3,'(A)',IOSTAT=Sttus)  Line   ! Read in the entire line

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully


         READ (Line,*)  TmpPer, TmpDir ! Read in only the period and direction from the WAMIT file


         IF ( FirstPass                           )  THEN   ! .TRUE. if we are on the first pass
            PrvPer = TmpPer            ! Store the current period    as the previous period    for the next pass
         ENDIF


         IF (                  TmpPer /= PrvPer   )  THEN   ! .TRUE.                                if the period    currently read in is different than the previous period    read in; thus we found a new period    in the WAMIT file, so stop reading in data
            EXIT
         ENDIF


         IF ( FirstPass .OR. ( TmpDir /= PrvDir ) )  THEN   ! .TRUE. if we are on the first pass or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
            NInpWvDir = NInpWvDir + 1  ! Since we found a new direction, count it in the total
            PrvDir    = TmpDir         ! Store the current direction as the previous direction for the next pass
            FirstPass = .FALSE.        ! Sorry, you can only have one first pass
         ENDIF


      ELSE                    ! We must have reached the end of the file, so stop reading in data


         EXIT


      ENDIF


   ENDDO ! End loop through all rows in the file


   REWIND (UNIT=UnW3)   ! REWIND the file so we can read it in a second time.


   ! Now that we know how many directions there are, we can ALLOCATE the arrays to
   !   to store the directions and frequency- and direction-dependent complex wave
   !   excitation force per unit wave amplitude vector:

   ALLOCATE ( WAMITWvDir  (NInpWvDir           ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the WAMITWvDir array.')
   ENDIF

   ALLOCATE ( SortWvDirInd(NInpWvDir           ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the SortWvDirInd array.')
   ENDIF

   ALLOCATE ( HdroWvDir   (NInpWvDir           ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the HdroWvDir array.')
   ENDIF

   ALLOCATE ( HdroExctn   (NInpFreq,NInpWvDir,6) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the HdroExctn array.')
   ENDIF


      ! Now find out how the directions are ordered in the file.  When we read in
      !   the wave excitation force vector, we need to have them sorted by
      !   increasing angle.  Thus, find the array of indices, SortWvDirInd(),
      !   such that WAMITWvDir(SortWvDirInd(:)) is sorted from lowest to highest
      !   angle.  At the same time, make sure that the frequencies in the .3 file are
      !   ordered in the same way they are in the .1 file and make sure that the
      !   directions are the same for each frequency component:

   K         = 0        ! Initialize to zero
   PrvPer    = 0.0      ! Initialize to a don't care
   PrvDir    = 0.0      ! Initialize to a don't care
   FirstPass = .TRUE.   ! Initialize to .TRUE. for the first pass

   DO    ! Loop through all rows in the file


      READ (UnW3,'(A)',IOSTAT=Sttus)  Line   ! Read in the entire line

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully


         READ (Line,*)  TmpPer, TmpDir ! Read in only the period and direction from the WAMIT file


         IF ( FirstPass .OR. ( TmpPer /= PrvPer ) )  THEN   ! .TRUE. if we are on the first pass or if the period    currently read in is different than the previous period    read in; thus we found a new period    in the WAMIT file!

            J         = 0           ! Reset the count of directions to zero
            K         = K + 1       ! This is current count of which frequency component we are on
            PrvPer    = TmpPer      ! Store the current period    as the previous period    for the next pass
            FirstFreq = FirstPass   ! Sorry, you can only loop through the first frequency once
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
            NewPer    = .TRUE.      ! Reset the new period flag
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

            DO WHILE ( WAMITPer(K) <= 0.0 )  ! Periods less than or equal to zero in WAMIT represent infinite period = zero frequency and infinite frequency, respectively.  However, only the added mass is output by WAMIT at these limits.  The damping and wave excitation are left blank, so skip them!
               K = K + 1
            ENDDO

            IF ( TmpPer /= WAMITPer(K) )  THEN  ! Abort if the .3 and .1 files do not contain the same frequency components (not counting zero and infinity)
               CALL ProgAbort ( ' Other than zero and infinite frequencies, "'   //TRIM(WAMITFile)//'.3",' // &
                            ' contains different frequency components than "'//TRIM(WAMITFile)//'.1". '// &
                            ' Both WAMIT output files must be generated from the same run.'                 )
            ENDIF

         ENDIF


!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
!remove6.02c         IF ( FirstPass .OR. ( TmpDir /= PrvDir ) )  THEN   ! .TRUE. if we are on the first pass or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
         IF ( FirstPass .OR. ( TmpDir /= PrvDir ) .OR. NewPer )  THEN   ! .TRUE. if we are on the first pass, or if this is new period, or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

            J         = J + 1       ! This is current count of which direction component we are on
            PrvDir    = TmpDir      ! Store the current direction as the previous direction for the next pass
            FirstPass = .FALSE.     ! Sorry, you can only have one first pass
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
            NewPer    = .FALSE.     ! Disable the new period flag
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

            IF ( FirstFreq )  THEN                    ! .TRUE. while we are still looping through all directions for the first frequency component
               WAMITWvDir(J)   = TmpDir      ! Store the directions in the order they appear in the WAMIT file

               InsertInd       = J           ! Initialize as the J'th component
               DO I = 1,J-1   ! Loop throuh all previous directions
                  IF ( ( WAMITWvDir(I) > WAMITWvDir(J) ) )  THEN  ! .TRUE. if a previous direction component is higher than the current direction component
                     InsertInd       = MIN( InsertInd, SortWvDirInd(I) )   ! Store the lowest sorted index whose associated direction component is higher than the current direction component
                     SortWvDirInd(I) = SortWvDirInd(I) + 1                 ! Shift all of the sorted indices up by 1 whose associated direction component is higher than the current direction component
                  ENDIF
               ENDDO          ! I - All previous directions
               SortWvDirInd(J) = InsertInd   ! Store the index such that WAMITWvDir(SortWvDirInd(:)) is sorted from lowest to highest direction
            ELSEIF ( TmpDir /= WAMITWvDir(J) )  THEN  ! We must have looped through all directions at least once; so check to make sure all subsequent directions are consistent with the directions from the first frequency component, otherwise Abort
               CALL ProgAbort ( ' Not every frequency component in "'//TRIM(WAMITFile)//'.3"'// &
                            ' contains the same listing of direction angles.  Check for' // &
                            ' errors in the WAMIT output file.'                               )
            ENDIF

         ENDIF


      ELSE                    ! We must have reached the end of the file, so stop reading in data


         EXIT


      ENDIF


   ENDDO ! End loop through all rows in the file


   REWIND (UNIT=UnW3)   ! REWIND the file so we can read it in a third time.  (This is getting ridiculous!)


      ! Now we can finally read in the frequency- and direction-dependent complex
      !   wave excitation force per unit wave amplitude vector:

   K                = 0       ! Initialize to zero
   PrvPer           = 0.0     ! Initialize to a don't care
   PrvDir           = 0.0     ! Initialize to a don't care
   FirstPass        = .TRUE.  ! Initialize to .TRUE. for the first pass

   HdroExctn(:,:,:) = 0.0     ! Initialize to zero

   DO    ! Loop through all rows in the file


      READ (UnW3,'(A)',IOSTAT=Sttus)  Line   ! Read in the entire line

      IF ( Sttus == 0 )  THEN ! .TRUE. when data is read in successfully


         READ (Line,*)  TmpPer, TmpDir, I, TmpData1, TmpData2, TmpRe, TmpIm   ! Read in the period, direction, row index, and nondimensional data from the WAMIT file


         IF ( FirstPass .OR. ( TmpPer /= PrvPer ) )  THEN   ! .TRUE. if we are on the first pass or if the period    currently read in is different than the previous period    read in; thus we found a new period    in the WAMIT file!

            J            = 0           ! Reset the count of directions to zero
            K            = K + 1       ! This is current count of which frequency component we are on
            PrvPer       = TmpPer      ! Store the current period    as the previous period    for the next pass
            FirstFreq    = FirstPass   ! Sorry, you can only loop through the first frequency once
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
            NewPer       = .TRUE.      ! Reset the new period flag
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

            DO WHILE ( WAMITPer(K) <= 0.0 )  ! Periods less than or equal to zero in WAMIT represent infinite period = zero frequency and infinite frequency, respectively.  However, only the added mass is output by WAMIT at these limits.  The damping and wave excitation are left blank, so skip them!
               K = K + 1
            ENDDO

         ENDIF


!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
!remove6.02c         IF ( FirstPass .OR. ( TmpDir /= PrvDir ) )  THEN   ! .TRUE. if we are on the first pass or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
         IF ( FirstPass .OR. ( TmpDir /= PrvDir ) .OR. NewPer )  THEN   ! .TRUE. if we are on the first pass, or if this is new period, or if the direction currently read in is different than the previous direction read in; thus we found a new direction in the WAMIT file!
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

            J            = J + 1       ! This is current count of which direction component we are on
            PrvDir       = TmpDir      ! Store the current direction as the previous direction for the next pass
            FirstPass    = .FALSE.     ! Sorry, you can only have one first pass
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Bug fix: Add logic to ensure WAMIT data is read in correctly even if
!jmj   NInpWvDir = 1:
            NewPer       = .FALSE.     ! Disable the new period flag
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

            IF ( FirstFreq )  THEN  ! .TRUE. while we are still looping through all directions for the first frequency component
               HdroWvDir(SortWvDirInd(J)) = TmpDir ! Store the directions sorted from lowest to highest
            ENDIF

         ENDIF


         HdroExctn(SortFreqInd(K),SortWvDirInd(J),I) = CMPLX( TmpRe, TmpIm )*DffrctDim(I) ! Redimensionalize the data and place it at the appropriate location within the array


      ELSE                    ! We must have reached the end of the file, so stop reading in data


         EXIT


      ENDIF


   ENDDO ! End loop through all rows in the file


   CLOSE ( UnW3 ) ! Close file.


   ! For some reason, WAMIT computes the zero- and infinite- frequency limits for
   !   only the added mass.  Based on hydrodynamic theory, the damping is zero at
   !   these limits (as initialized).  Hydrodynamic theory also says that the
   !   infinite-frequency limit of the diffraction force is zero (as initialized);
   !   however, the zero-frequency limit need not be zero.  Thus, if necessary
   !   (i.e., if we have read in a WAMIT output file that contains the
   !   zero-frequency limit of the added mass), compute the zero-frequency limit
   !   of the diffraction problem using the known values at the lowest
   !   nonzero-valued frequency available:

   DO I = 1,NInpFreq       ! Loop through all input frequency components

      IF ( HdroFreq(I) > 0.0 )  THEN ! .TRUE. at the lowest nonzero-valued frequency component

         DO J = I-1,1,-1   ! Loop through all zero-valued frequency components
            HdroExctn(J,:,:) = HdroExctn(I,:,:) ! Set the zero-frequency limits to equal the known values at the lowest nonzero-valued frequency available
         ENDDO             ! J - All zero-valued frequency components

         EXIT  ! Since HdroFreq(:) is sorted from lowest to highest frequency, there is no reason to continue on once we have found the lowest nonzero-valued frequency component

      ENDIF

   ENDDO                   ! I - All input frequency components




      ! Tell our nice users what is about to happen that may take a while:

   CALL WrScr ( ' Computing radiation impulse response functions and wave diffraction forces.' )



      ! Abort if the WAMIT files do not contain both the zero- and and infinite-
      !   frequency limits of added mass.  Also, if HighFreq is greater than
      !   RdtnOmegaMax, Abort because RdtnDT must be reduced in order to have
      !   sufficient accuracy in the computation of the radiation impulse response
      !   functions:

   IF ( .NOT. ( ZeroFreq .AND. InfFreq ) )  THEN   ! .TRUE. if both the zero- and infinite-frequency limits of added mass are contained within the WAMIT file
      CALL ProgAbort ( ' "'//TRIM(WAMITFile)//'.1" must contain both the zero- and infinite-frequency limits of added mass.' )
   ELSEIF ( HighFreq > RdtnOmegaMax      )  THEN   ! .TRUE. if the highest frequency component (not counting infinity) in the WAMIT file is greater than RdtnOmegaMax
      CALL ProgAbort ( ' Based on the frequency range found in "'//TRIM(WAMITFile)//'.1",'       // &
                   ' RdtnDT must be set smaller than '//TRIM(Flt2LStr( Pi/HighFreq ))//' sec'// &
                   ' in order to accurately compute the radiation impulse response functions.'    )
   ENDIF



      ! Set the infinite-frequency limit of the frequency-dependent hydrodynamic
      !   added mass matrix, HdroAdMsI, based on the highest frequency available:

   Indx = 0
   DO J = 1,6        ! Loop through all rows    of HdroAdMsI
      DO K = J,6     ! Loop through all columns of HdroAdMsI above and including the diagonal
         Indx = Indx + 1
         HdroAdMsI(J,K) = HdroAddMs(NInpFreq,Indx)
      ENDDO          ! K - All columns of HdroAdMsI above and including the diagonal
      DO K = J+1,6   ! Loop through all rows    of HdroAdMsI below the diagonal
         HdroAdMsI(K,J) = HdroAdMsI(J,K)
      ENDDO          ! K - All rows    of HdroAdMsI below the diagonal
   ENDDO             ! J - All rows    of HdroAdMsI



      ! Perform some initialization computations including calculating the total
      !   number of frequency components = total number of time steps in the wave,
      !   radiation kernel, calculating the frequency step, and ALLOCATing the
      !   arrays:
      ! NOTE: RdtnDOmega = Pi/RdtnTMax since, in the (co)sine transforms:
      !          Omega = (K-1)*RdtnDOmega
      !          Time  = (J-1)*RdtnDT
      !       and therefore:
      !          Omega*Time = (K-1)*(J-1)*RdtnDOmega*RdtnDT
      !                     = (K-1)*(J-1)*Pi/(NStepRdtn-1) [see FFT_Module]
      !       or:
      !          RdtnDOmega = Pi/((NStepRdtn-1)*RdtnDT)
      !                     = Pi/RdtnTMax

   NStepRdtn  = CEILING ( RdtnTMax/RdtnDT )                 ! Set NStepRdtn to an odd integer
   IF ( MOD(NStepRdtn,2) == 0 )  NStepRdtn = NStepRdtn + 1  !   larger or equal to RdtnTMax/RdtnDT.
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Put a MAX(*,1) in the calculation of NStepWave2 and NStepRdtn2 to ensure
!jmj   that routine PSF() does not crash when WaveTMax and/or RdtnTMax are very
!jmj   small:
!remove6.02b   NStepRdtn2 = ( NStepRdtn-1 )/2                           ! Make sure that NStepRdtn-1 is an even product of small factors (PSF) that is greater
   NStepRdtn2 = MAX( ( NStepRdtn-1 )/2, 1 )                 ! Make sure that NStepRdtn-1 is an even product of small factors (PSF) that is greater
!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
   NStepRdtn  = 2*PSF ( NStepRdtn2, 9 ) + 1                 !   or equal to RdtnTMax/RdtnDT to ensure that the (co)sine transform is efficient.

   NStepRdtn1 = NStepRdtn + 1                               ! Save the value of NStepRdtn + 1 for future use.
   NStepRdtn2 = ( NStepRdtn-1 )/2                           ! Update the value of NStepRdtn2 based on the value needed for NStepRdtn.
   RdtnTMax   = ( NStepRdtn-1 )*RdtnDT                      ! Update the value of RdtnTMax   based on the value needed for NStepRdtn.
   RdtnDOmega = Pi/RdtnTMax                                 ! Compute the frequency step for wave radiation kernel calculations.

   ALLOCATE ( RdtnTime (0:NStepRdtn-1    ) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the RdtnTime array.')
   ENDIF

   ALLOCATE ( RdtnKrnl (0:NStepRdtn-1,6,6) , STAT=Sttus )
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the RdtnKrnl array.')
   ENDIF

   ALLOCATE ( XDHistory(0:NStepRdtn  ,6  ) , STAT=Sttus )   ! In the numerical convolution we must have NStepRdtn1 elements within the XDHistory array, which is one more than the NStepRdtn elements that are in the RdtnKrnl array
   IF ( Sttus /= 0 )  THEN
      CALL ProgAbort(' Error allocating memory for the XDHistory array.')
   ENDIF



   IF ( RdtnFrmAM )  THEN  ! .TRUE. if we will determine the wave radiation kernel from the frequency-dependent hydrodynamic added mass matrix



      ! Calculate the factor needed by the discrete sine transform in the
      !   calculation of the wave radiation kernel:

      Krnl_Fact = -1.0/RdtnDT ! This factor is needed by the discrete time sine transform



      ! Compute all frequency components (including zero) of the sine transform
      !   of the wave radiation kernel:

      DO I = 0,NStepRdtn-1 ! Loop through all frequency components (including zero) of the sine transform


      ! Calculate the array of simulation times at which the instantaneous values
      !   of the wave radiation kernel are to be determined:

         RdtnTime(I) = I*RdtnDT


      ! Compute the frequency of this component:

         Omega = I*RdtnDOmega


      ! Compute the upper-triangular portion (diagonal and above) of the sine
      !   transform of the wave radiation kernel:

         Indx = 0
         DO J = 1,6        ! Loop through all rows    of RdtnKrnl
            DO K = J,6     ! Loop through all columns of RdtnKrnl above and including the diagonal
               Indx = Indx + 1
               RdtnKrnl(I,J,K) = Krnl_Fact*Omega*( InterpStp( Omega, HdroFreq(:), HdroAddMs(:       ,Indx), LastInd, NInpFreq ) &
                                                   -                              HdroAddMs(NInpFreq,Indx)                        )
            ENDDO          ! K - All columns of RdtnKrnl above and including the diagonal
         ENDDO             ! J - All rows    of RdtnKrnl


      ENDDO                ! I - All frequency components (including zero) of the sine transform



      ! Compute the sine transforms to find the time-domain representation of
      !   the wave radiation kernel:

      CALL InitSINT ( NStepRdtn, .TRUE. )

      DO J = 1,6                 ! Loop through all rows    of RdtnKrnl
         DO K = J,6              ! Loop through all columns of RdtnKrnl above and including the diagonal
            CALL ApplySINT( RdtnKrnl(:,J,K) )
         ENDDO                   ! K - All columns of RdtnKrnl above and including the diagonal
         DO K = J+1,6            ! Loop through all rows    of RdtnKrnl below the diagonal
            DO I = 0,NStepRdtn-1 ! Loop through all frequency components (including zero) of the sine transform
               RdtnKrnl(I,K,J) = RdtnKrnl(I,J,K)
            ENDDO                ! I - All frequency components (including zero) of the sine transform
         ENDDO                   ! K - All rows    of RdtnKrnl below the diagonal
      ENDDO                      ! J - All rows    of RdtnKrnl

      CALL ExitSINT



   ELSE                    ! We must be determining the wave radiation kernel from the frequency-dependent hydrodynamic damping matrix



      ! Calculate the factor needed by the discrete cosine transform in the
      !   calculation of the wave radiation kernel:

      Krnl_Fact = 1.0/RdtnDT  ! This factor is needed by the discrete time cosine transform



      ! Compute all frequency components (including zero) of the cosine transform
      !   of the wave radiation kernel:

      DO I = 0,NStepRdtn-1 ! Loop through all frequency components (including zero) of the cosine transform


      ! Calculate the array of simulation times at which the instantaneous values
      !   of the wave radiation kernel are to be determined:

         RdtnTime(I) = I*RdtnDT


      ! Compute the frequency of this component:

         Omega = I*RdtnDOmega


      ! Compute the upper-triangular portion (diagonal and above) of the cosine
      !   transform of the wave radiation kernel:

         Indx = 0
         DO J = 1,6        ! Loop through all rows    of RdtnKrnl
            DO K = J,6     ! Loop through all columns of RdtnKrnl above and including the diagonal
               Indx = Indx + 1
               RdtnKrnl(I,J,K) = Krnl_Fact*InterpStp ( Omega, HdroFreq(:), HdroDmpng(:,Indx), LastInd, NInpFreq )
            ENDDO          ! K - All columns of RdtnKrnl above and including the diagonal
         ENDDO             ! J - All rows    of RdtnKrnl


      ENDDO                ! I - All frequency components (including zero) of the cosine transform



      ! Compute the cosine transforms to find the time-domain representation of
      !   the wave radiation kernel:

      CALL InitCOST ( NStepRdtn, .TRUE. )

      DO J = 1,6                 ! Loop through all rows    of RdtnKrnl
         DO K = J,6              ! Loop through all columns of RdtnKrnl above and including the diagonal
            CALL ApplyCOST( RdtnKrnl(:,J,K) )
         ENDDO                   ! K - All columns of RdtnKrnl above and including the diagonal
         DO K = J+1,6            ! Loop through all rows    of RdtnKrnl below the diagonal
            DO I = 0,NStepRdtn-1 ! Loop through all radiation time steps
               RdtnKrnl(I,K,J) = RdtnKrnl(I,J,K)
            ENDDO                ! I - All radiation time steps
         ENDDO                   ! K - All rows    of RdtnKrnl below the diagonal
      ENDDO                      ! J - All rows    of RdtnKrnl

      CALL ExitCOST



   ENDIF
!JASON:USE THIS TO TEST ADDED MASS:DO I = 1,6  !JASON:USE THIS TO TEST ADDED MASS:
!JASON:USE THIS TO TEST ADDED MASS:DO J = 1,6  !JASON:USE THIS TO TEST ADDED MASS:
!JASON:USE THIS TO TEST ADDED MASS:   WRITE (*,*) I, J, HdroAdMsI(I,J) !JASON:USE THIS TO TEST ADDED MASS:
!JASON:USE THIS TO TEST ADDED MASS:ENDDO  !JASON:USE THIS TO TEST ADDED MASS:
!JASON:USE THIS TO TEST ADDED MASS:ENDDO  !JASON:USE THIS TO TEST ADDED MASS:
!JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:DO I = 0,NStepRdtn-1 ! Loop through all radiation time steps   !JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:
!JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:   WRITE (*,*) RdtnTime(I), RdtnKrnl(I,1,1), RdtnKrnl(I,3,3)   !JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:
!JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:   WRITE (*,*) RdtnTime(I), RdtnKrnl(I,4,4), RdtnKrnl(I,6,6)   !JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:
!JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:   WRITE (*,*) RdtnTime(I), RdtnKrnl(I,1,5), RdtnKrnl(I,2,4)   !JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:
!JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:ENDDO                ! I - All radiation time steps   !JASON:USE THIS TO TEST IMPULSE RESPONSE FUNCTIONS:




      ! Initialize the variables associated with the incident wave:

   SELECT CASE ( WaveMod ) ! Which incident wave kinematics model are we using?

   CASE ( 0 )              ! None=still water.



      ! Initialize everything to zero:

      ALLOCATE ( WaveExctn (0:NStepWave-1,6) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveExctn array.')
      ENDIF

      WaveExctn = 0.0




   CASE ( 1, 2, 3 )        ! Plane progressive (regular) wave, JONSWAP/Pierson-Moskowitz spectrum (irregular) wave, or user-defined spectrum (irregular) wave.



      ! Abort if we have chosen a wave heading direction that is outside the range
      !   of directions where the complex wave excitation force per unit wave
      !   amplitude vector has been defined, else interpolate to find the complex
      !   wave excitation force per unit wave amplitude vector at the chosen wave
      !   heading direction:

!BJJ START of proposed change v7.00.01a-bjj
!bjj: line is too long
!RM      IF ( ( WaveDir < HdroWvDir(1) ) .OR. ( WaveDir > HdroWvDir(NInpWvDir) ) )  &
!RM         CALL ProgAbort ( ' WaveDir must be within the wave heading angle range available in "'//TRIM(WAMITFile)//'.3" (inclusive).' )
      IF ( ( WaveDir < HdroWvDir(1) ) .OR. ( WaveDir > HdroWvDir(NInpWvDir) ) )  THEN
         CALL ProgAbort ( ' WaveDir must be within the wave heading angle range available in "' &
                           //TRIM(WAMITFile)//'.3" (inclusive).' )
      END IF
!BJJ END OF PROPOSED CHANGE

      ALLOCATE ( X_Diffrctn(NInpFreq,6) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the X_Diffrctn array.')
      ENDIF

      DO J = 1,6           ! Loop through all wave excitation forces and moments
         DO I = 1,NInpFreq ! Loop through all input frequency components inherent in the complex wave excitation force per unit wave amplitude vector
!bjj start of proposed change v6.02d-bjj
!rm            X_Diffrctn(I,J) = InterpStp_CMPLX ( WaveDir, HdroWvDir(:), HdroExctn(I,:,J), LastInd, NInpWvDir )
            X_Diffrctn(I,J) = InterpStp( WaveDir, HdroWvDir(:), HdroExctn(I,:,J), LastInd, NInpWvDir )
!bjj end of proposed change
         ENDDO             ! I - All input frequency components inherent in the complex wave excitation force per unit wave amplitude vector
      ENDDO                ! J - All wave excitation forces and moments



      ! ALLOCATE the arrays:

      ALLOCATE ( WaveExctnC(0:NStepWave2 ,6) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveExctnC array.')
      ENDIF

      ALLOCATE ( WaveExctn (0:NStepWave-1,6) , STAT=Sttus )
      IF ( Sttus /= 0 )  THEN
         CALL ProgAbort(' Error allocating memory for the WaveExctn array.')
      ENDIF



      ! Compute the positive-frequency components (including zero) of the Fourier
      !  transforms of the wave excitation force:

      DO I = 0,NStepWave2  ! Loop through the positive frequency components (including zero) of the Fourier transforms


      ! Compute the frequency of this component:

         Omega = I*WaveDOmega


      ! Compute the Fourier transform of the instantaneous value of the total
      !   excitation force on the support platfrom from incident waves:

         DO J = 1,6           ! Loop through all wave excitation forces and moments
!bjj start of proposed change v6.02d-bjj
!rm            WaveExctnC(I,J) = WaveElevC0(I)*InterpStp_CMPLX ( Omega, HdroFreq(:), X_Diffrctn(:,J), LastInd, NInpFreq )
            WaveExctnC(I,J) = WaveElevC0(I)*InterpStp ( Omega, HdroFreq(:), X_Diffrctn(:,J), LastInd, NInpFreq )
!bjj end of proposed change v6.02d-bjj
         ENDDO                ! J - All wave excitation forces and moments


      ENDDO                ! I - The positive frequency components (including zero) of the Fourier transforms



      ! Compute the inverse Fourier transforms to find the time-domain
      !   representations of the wave excitation forces:

      CALL InitFFT ( NStepWave, .TRUE. )

      DO J = 1,6           ! Loop through all wave excitation forces and moments
         CALL ApplyFFT_cx ( WaveExctn(:,J), WaveExctnC(:,J) )
      ENDDO                ! J - All wave excitation forces and moments

      CALL ExitFFT




   CASE ( 4 )              ! GH Bladed wave data.



      CALL ProgAbort ( ' GH Bladed wave data not applicable for floating platforms. ')




   ENDSELECT


!bjj start of proposed change
      ! deallocate arrays
         
   IF ( ALLOCATED( HdroExctn    ) ) DEALLOCATE( HdroExctn    )
   IF ( ALLOCATED( WaveExctnC   ) ) DEALLOCATE( WaveExctnC   )
   IF ( ALLOCATED( X_Diffrctn   ) ) DEALLOCATE( X_Diffrctn   )
   IF ( ALLOCATED( HdroAddMs    ) ) DEALLOCATE( HdroAddMs    )
   IF ( ALLOCATED( HdroDmpng    ) ) DEALLOCATE( HdroDmpng    )
   IF ( ALLOCATED( HdroFreq     ) ) DEALLOCATE( HdroFreq     )
   IF ( ALLOCATED( HdroWvDir    ) ) DEALLOCATE( HdroWvDir    )
   IF ( ALLOCATED( RdtnTime     ) ) DEALLOCATE( RdtnTime     )
   IF ( ALLOCATED( WAMITFreq    ) ) DEALLOCATE( WAMITFreq    )
   IF ( ALLOCATED( WAMITPer     ) ) DEALLOCATE( WAMITPer     )
   IF ( ALLOCATED( WAMITWvDir   ) ) DEALLOCATE( WAMITWvDir   )
   IF ( ALLOCATED( SortFreqInd  ) ) DEALLOCATE( SortFreqInd  )
   IF ( ALLOCATED( SortWvDirInd ) ) DEALLOCATE( SortWvDirInd )
         
         
!bjj end of proposed change

   RETURN
   END SUBROUTINE InitFltngPtfmLd
!jmj Start of proposed change.  v6.02b-jmj  15-Nov-2006.
!jmj Replace the hard-coded mooring line restoring calculation with a general
!jmj   purpose, quasi-static solution based on the analytical catenary cable
!jmj   equations with seabed interaction:
!=======================================================================
   FUNCTION LinePosition ( ILine, JNode, KDirection )


      ! This FUNCTION is used to return the instantaneous line position at
      ! node JNode of mooring line ILine in the xi- (KDirection=1), yi-
      ! (KDirection=2), or zi- (KDirection=3) direction, respectively, to
      ! the calling program.


   USE                             Precision


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi)                   :: LinePosition                                    ! This function = instantaneous line position at node JNode of mooring line ILine in the inertia frame (meters)

   INTEGER(4), INTENT(IN )      :: ILine                                           ! Mooring line number (-)
   INTEGER(4), INTENT(IN )      :: JNode                                           ! The index of the current mooring line node (-)
   INTEGER(4), INTENT(IN )      :: KDirection                                      ! 1, 2, or 3, for the xi-, yi-, or zi-directions, respectively (-)

!bjj start of proposed change v6.02d
!rm      ! Global functions:
!rm
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Abort if the mooring line parameters have not been computed yet, if ILine
      !   is not one of the existing mooring lines, if JNode is not one of the
      !   existing line nodes, or if KDirection is not specified properly:

   IF ( .NOT. ALLOCATED ( LNodesPi )                   )  THEN
      CALL ProgAbort ( ' Routine InitFltngPtfmLd() must be called before routine LinePosition().' )
   ELSEIF ( ( ILine < 1 ) .OR. ( ILine > NumLines  )   )  THEN
      CALL ProgAbort ( ' Mooring line '//TRIM( Int2LStr( ILine ) )//' has not been analyzed.' )
   ELSEIF ( ( JNode < 1 ) .OR. ( JNode > LineNodes )   )  THEN
      CALL ProgAbort ( ' Line node '   //TRIM( Int2LStr( Jnode ) )//' has not been analyzed.' )
   ELSEIF ( ( KDirection < 1 ) .OR. ( KDirection > 3 ) )  THEN
      CALL ProgAbort ( ' KDirection must be 1, 2, or 3 in routine LinePosition().'          )
   ENDIF



      ! Return the instantaneous line position:

   LinePosition = LNodesPi(ILine,JNode,KDirection)



   RETURN
   END FUNCTION LinePosition
!=======================================================================
   FUNCTION LineTension ( ILine, JNode )


      ! This FUNCTION is used to return the instantaneous effective line
      ! tension at node JNode of mooring line ILine to the calling program.


   USE                             Precision


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi)                   :: LineTension                                     ! This function = instantaneous effective line tension at node JNode of mooring line ILine (N)

   INTEGER(4), INTENT(IN )      :: ILine                                           ! Mooring line number (-)
   INTEGER(4), INTENT(IN )      :: JNode                                           ! The index of the current mooring line node (-)


!bjj start of proposed change v6.02d
!rm      ! Global functions:
!rm
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Abort if the mooring line parameters have not been computed yet, if ILine
      !   is not one of the existing mooring lines, or if JNode is not one of the
      !   existing line nodes:

   IF ( .NOT. ALLOCATED ( LNodesTe )                 )  THEN
      CALL ProgAbort ( ' Routine InitFltngPtfmLd() must be called before routine LineTension().' )
   ELSEIF ( ( ILine < 1 ) .OR. ( ILine > NumLines  ) )  THEN
      CALL ProgAbort ( ' Mooring line '//TRIM( Int2LStr( ILine ) )//' has not been analyzed.' )
   ELSEIF ( ( JNode < 1 ) .OR. ( JNode > LineNodes ) )  THEN
      CALL ProgAbort ( ' Line node '   //TRIM( Int2LStr( Jnode ) )//' has not been analyzed.' )
   ENDIF



      ! Return the instantaneous effective tension:

   LineTension = LNodesTe(ILine,JNode)



   RETURN
   END FUNCTION LineTension
!=======================================================================
!bjj start of propsoed chagne
!subroutine moved to NWTC_Num.f90
!!JASON: THIS ROUTINE (SmllRotTrans) SHOULD BE MOVED TO NWTC_Subs!!!
!   SUBROUTINE SmllRotTrans( RotationType, Theta1, Theta2, Theta3, TransMat )
!
!
!      ! This routine computes the 3x3 transformation matrix, TransMat,
!      !   to a coordinate system x (with orthogonal axes x1, x2, x3)
!      !   resulting from three rotations (Theta1, Theta2, Theta3) about the
!      !   orthogonal axes (X1, X2, X3) of coordinate system X.  All angles
!      !   are assummed to be small, as such, the order of rotations does
!      !   not matter and Euler angles do not need to be used.  This routine
!      !   is used to compute the transformation matrix (TransMat) between
!      !   undeflected (X) and deflected (x) coordinate systems.  In matrix
!      !   form:
!      !      {x1}   [TransMat(Theta1, ] {X1}
!      !      {x2} = [         Theta2, ]*{X2}
!      !      {x3}   [         Theta3 )] {X3}
!
!      ! The transformation matrix, TransMat, is the closest orthonormal
!      !   matrix to the nonorthonormal, but skew-symmetric, Bernoulli-Euler
!      !   matrix:
!      !          [   1.0    Theta3 -Theta2 ]
!      !      A = [ -Theta3   1.0    Theta1 ]
!      !          [  Theta2 -Theta1   1.0   ]
!      !
!      !   In the Frobenius Norm sense, the closest orthornormal matrix is:
!      !      TransMat = U*V^T,
!      !
!      !   where the columns of U contain the eigenvectors of A*A^T and the
!      !   columns of V contain the eigenvectors of A^T*A (^T = transpose).
!      !   This result comes directly from the Singular Value Decomposition
!      !   (SVD) of A = U*S*V^T where S is a diagonal matrix containing the
!      !   singular values of A, which are SQRT( eigenvalues of A*A^T ) =
!      !   SQRT( eigenvalues of A^T*A ).
!
!      ! The algebraic form of the transformation matrix, as implemented
!      !   below, was derived symbolically by J. Jonkman by computing U*V^T
!      !   by hand with verification in Mathematica.
!
!      ! NOTE: This routine is an exact copy of SUBROUTINE SmllRotTrans() given in
!      !       FAST source file FAST.f90.
!
!
!   USE                             Precision
!   USE                             SysSubs
!
!
!   IMPLICIT                        NONE
!
!
!      ! Passed Variables:
!
!   REAL(ReKi), INTENT(IN )      :: Theta1                                          ! The small rotation about X1, (rad).
!   REAL(ReKi), INTENT(IN )      :: Theta2                                          ! The small rotation about X2, (rad).
!   REAL(ReKi), INTENT(IN )      :: Theta3                                          ! The small rotation about X3, (rad).
!   REAL(ReKi), INTENT(OUT)      :: TransMat (3,3)                                  ! The resulting transformation matrix from X to x, (-).
!
!   CHARACTER(*), INTENT(IN)     :: RotationType                                    ! The type of rotation; used to inform the user where a large rotation is occuring upon such an event.
!
!
!      ! Local Variables:
!
!   REAL(ReKi)                   :: ComDenom                                        ! = ( Theta1^2 + Theta2^2 + Theta3^2 )*SQRT( 1.0 + Theta1^2 + Theta2^2 + Theta3^2 )
!   REAL(ReKi), PARAMETER        :: LrgAngle  = 0.4                                 ! Threshold for when a small angle becomes large (about 23deg).  This comes from: COS(SmllAngle) ~ 1/SQRT( 1 + SmllAngle^2 ) and SIN(SmllAngle) ~ SmllAngle/SQRT( 1 + SmllAngle^2 ) results in ~5% error when SmllAngle = 0.4rad.
!   REAL(ReKi)                   :: Theta11                                         ! = Theta1^2
!   REAL(ReKi)                   :: Theta12S                                        ! = Theta1*Theta2*[ SQRT( 1.0 + Theta1^2 + Theta2^2 + Theta3^2 ) - 1.0 ]
!   REAL(ReKi)                   :: Theta13S                                        ! = Theta1*Theta3*[ SQRT( 1.0 + Theta1^2 + Theta2^2 + Theta3^2 ) - 1.0 ]
!   REAL(ReKi)                   :: Theta22                                         ! = Theta2^2
!   REAL(ReKi)                   :: Theta23S                                        ! = Theta2*Theta3*[ SQRT( 1.0 + Theta1^2 + Theta2^2 + Theta3^2 ) - 1.0 ]
!   REAL(ReKi)                   :: Theta33                                         ! = Theta3^2
!   REAL(ReKi)                   :: SqrdSum                                         ! = Theta1^2 + Theta2^2 + Theta3^2
!   REAL(ReKi)                   :: SQRT1SqrdSum                                    ! = SQRT( 1.0 + Theta1^2 + Theta2^2 + Theta3^2 )
!
!   LOGICAL,    SAVE             :: FrstWarn  = .TRUE.                              ! When .TRUE., indicates that we're on the first warning.
!
!
!
!      ! Display a warning message if at least one angle gets too large in
!      !   magnitude:
!
!   IF ( ( ( ABS(Theta1) > LrgAngle ) .OR. ( ABS(Theta2) > LrgAngle ) .OR. ( ABS(Theta3) > LrgAngle ) ) .AND. FrstWarn )  THEN
!
!      CALL WrOver(' WARNING:                                                            ')
!      CALL WrScr ('  Small angle assumption violated in SUBROUTINE SmllRotTrans() due to')
!      CALL WrScr ('  a large '//TRIM(RotationType)//'.  The solution may be inaccurate. ')
!      CALL WrScr ('  Future warnings suppressed.  Simulation continuing...              ')
!      CALL WrScr ('                                                                     ')
!
!      CALL UsrAlarm
!
!
!      FrstWarn = .FALSE.   ! Don't enter here again!
!
!   ENDIF
!
!
!
!      ! Compute some intermediate results:
!
!   Theta11      = Theta1*Theta1
!   Theta22      = Theta2*Theta2
!   Theta33      = Theta3*Theta3
!
!   SqrdSum      = Theta11 + Theta22 + Theta33
!   SQRT1SqrdSum = SQRT( 1.0 + SqrdSum )
!   ComDenom     = SqrdSum*SQRT1SqrdSum
!
!   Theta12S     = Theta1*Theta2*( SQRT1SqrdSum - 1.0 )
!   Theta13S     = Theta1*Theta3*( SQRT1SqrdSum - 1.0 )
!   Theta23S     = Theta2*Theta3*( SQRT1SqrdSum - 1.0 )
!
!
!      ! Define the transformation matrix:
!
!   IF ( ComDenom == 0.0 )  THEN  ! All angles are zero and matrix is ill-conditioned (the matrix is derived assuming that the angles are not zero); return identity
!
!      TransMat(1,:) = (/ 1.0, 0.0, 0.0 /)
!      TransMat(2,:) = (/ 0.0, 1.0, 0.0 /)
!      TransMat(3,:) = (/ 0.0, 0.0, 1.0 /)
!
!   ELSE                          ! At least one angle is nonzero
!
!      TransMat(1,1) = ( Theta11*SQRT1SqrdSum + Theta22              + Theta33              )/ComDenom
!      TransMat(2,2) = ( Theta11              + Theta22*SQRT1SqrdSum + Theta33              )/ComDenom
!      TransMat(3,3) = ( Theta11              + Theta22              + Theta33*SQRT1SqrdSum )/ComDenom
!      TransMat(1,2) = (  Theta3*SqrdSum + Theta12S )/ComDenom
!      TransMat(2,1) = ( -Theta3*SqrdSum + Theta12S )/ComDenom
!      TransMat(1,3) = ( -Theta2*SqrdSum + Theta13S )/ComDenom
!      TransMat(3,1) = (  Theta2*SqrdSum + Theta13S )/ComDenom
!      TransMat(2,3) = (  Theta1*SqrdSum + Theta23S )/ComDenom
!      TransMat(3,2) = ( -Theta1*SqrdSum + Theta23S )/ComDenom
!
!   ENDIF
!
!
!
!   RETURN
!   END SUBROUTINE SmllRotTrans
!!jmj End of proposed change.  v6.02b-jmj  15-Nov-2006.
!bjj end of propsoed change
!=======================================================================
!bjj start of proposed change
   SUBROUTINE FP_Terminate( )
   
      ! Deallocate arrays
      
   IF ( ALLOCATED( LAnchHTe  ) ) DEALLOCATE(LAnchHTe  ) 
   IF ( ALLOCATED( LAnchVTe  ) ) DEALLOCATE(LAnchVTe  ) 
   IF ( ALLOCATED( LAnchxi   ) ) DEALLOCATE(LAnchxi   ) 
   IF ( ALLOCATED( LAnchyi   ) ) DEALLOCATE(LAnchyi   ) 
   IF ( ALLOCATED( LAnchzi   ) ) DEALLOCATE(LAnchzi   ) 
   IF ( ALLOCATED( LEAStff   ) ) DEALLOCATE(LEAStff   ) 
   IF ( ALLOCATED( LFairHTe  ) ) DEALLOCATE(LFairHTe  ) 
   IF ( ALLOCATED( LFairVTe  ) ) DEALLOCATE(LFairVTe  ) 
   IF ( ALLOCATED( LFairxt   ) ) DEALLOCATE(LFairxt   ) 
   IF ( ALLOCATED( LFairyt   ) ) DEALLOCATE(LFairyt   ) 
   IF ( ALLOCATED( LFairzt   ) ) DEALLOCATE(LFairzt   ) 
   IF ( ALLOCATED( LFldWght  ) ) DEALLOCATE(LFldWght  ) 
   IF ( ALLOCATED( LNodesPi  ) ) DEALLOCATE(LNodesPi  ) 
   IF ( ALLOCATED( LNodesTe  ) ) DEALLOCATE(LNodesTe  ) 
   IF ( ALLOCATED( LNodesX   ) ) DEALLOCATE(LNodesX   ) 
   IF ( ALLOCATED( LNodesZ   ) ) DEALLOCATE(LNodesZ   ) 
   IF ( ALLOCATED( LSeabedCD ) ) DEALLOCATE(LSeabedCD ) 
   IF ( ALLOCATED( LSNodes   ) ) DEALLOCATE(LSNodes   ) 
   IF ( ALLOCATED( LTenTol   ) ) DEALLOCATE(LTenTol   ) 
   IF ( ALLOCATED( LUnstrLen ) ) DEALLOCATE(LUnstrLen ) 
   IF ( ALLOCATED( RdtnKrnl  ) ) DEALLOCATE(RdtnKrnl  ) 
   IF ( ALLOCATED( WaveExctn ) ) DEALLOCATE(WaveExctn ) 
   IF ( ALLOCATED( XDHistory ) ) DEALLOCATE(XDHistory ) 
   
      ! Close files
   
   
   ! close files
   
   END SUBROUTINE FP_Terminate

!=======================================================================
!bjj end of proposed change

END MODULE FloatingPlatform
!=======================================================================
MODULE FixedBottomSupportStructure


   ! This MODULE stores variables and routines used in these time domain
   !   hydrodynamic loading for the fixed-bottom offshore support
   !   structures.


USE                             Precision


CONTAINS
!=======================================================================
   SUBROUTINE MorisonTwrLd ( JNode, TwrDiam, TwrCA, TwrCD, X, XD, ZTime, TwrAM, TwrFt )
!bjj: input X is not used

!JASON: WE MUST CORRECT THE CALCULATIONS IN THIS ROUTINE!: CREATE AND STORE EXTRA ARRAYS OF WAVE KINEMATICS AT THE FREE SURFACE AND SEABED.  USE THESE ARRAYS TO COMPUTE THE WAVE KINEMATICS FOR ELEMENTS THAT ARE ONLY PARTIALLY IMMERSED IN FLUID (I.E., WHERE THE WAVE ELEVATION IS JUST BELOW THE CURRENT TOWER NODE OR THE SEABED IS JUST ABOVE THE CURRENT TOWER NODE).  FOR GH BLADED WAVE DATA, FORM THESE ARRAYS USING THE HIGHEST OR LOWEST AVAILABLE WAVE DATA.  WITHOUT THIS FIX, ONE SHOULD GET ARROUND THE PROBLEM BY USING A FINE RESOLUTION OF TOWER ELEMENTS OVER THE PORTION OF THE TOWER THAT MAY END UP BEING COVERED OR UNCOVERED BY THE INCIDENT WAVES.
!JASON: USE THE UNDEFLECTED / UNDISPLACED TOWER ELEMENT LOCATION AND ORIENTATION TO BEGIN WITH; INCLUDE THE EFFECTS OF THE INSTANTANEOUS ELEMENT LOCATION AND ORIENTATION LATER!!!
       ! This routine is used to implement Morison's equation for the
       ! hydrodynamic loading on a monopile.


   USE                             Precision
   USE                             Waves


   IMPLICIT                        NONE


      ! Passed Variables:

   REAL(ReKi), INTENT(OUT)      :: TwrAM  (6,6)                                    ! Added mass matrix per unit length of current tower element (kg/m, kg-m/m, kg-m^2/m)
   REAL(ReKi), INTENT(IN )      :: TwrCA                                           ! Normalized hydrodynamic added mass   coefficient of current tower element (-)
   REAL(ReKi), INTENT(IN )      :: TwrCD                                           ! Normalized hydrodynamic viscous drag coefficient of current tower element (-)
   REAL(ReKi), INTENT(IN )      :: TwrDiam                                         ! Diameter of current tower element (meters)
   REAL(ReKi), INTENT(OUT)      :: TwrFt    (6)                                    ! The surge/xi (1), sway/yi (2), and heave/zi (3)-components of the portion of the tower force per unit length (in N/m) at the current tower element and the roll/xi (4), pitch/yi (5), and yaw/zi (6)-components of the portion of the tower moment per unit length (in N-m/m) acting at the current tower element associated with everything but the added-mass effects; positive forces are in the direction of motion.
   REAL(ReKi), INTENT(IN )      :: X        (6)                                    ! The 3 components of the translational displacement (in m  ) of the current tower node and the 3 components of the rotational displacement       (in rad  ) of the current tower element relative to the inertial frame origin at ground level [onshore] or MSL [offshore].
   REAL(ReKi), INTENT(IN )      :: XD       (6)                                    ! The 3 components of the translational velocity     (in m/s) of the current tower node and the 3 components of the rotational (angular) velocity (in rad/s) of the current tower element relative to the inertial frame origin at ground level [onshore] or MSL [offshore].
   REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time (sec)

   INTEGER(4), INTENT(IN )      :: JNode                                           ! The number of the current tower node / element (-) [1 to TwrNodes]


      ! Local Variables:

!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c   REAL(ReKi)                   :: DZFract                                         ! The fraction of the current tower element that is below the free surface of the incident wave and above the seabed (0.0 <= DZFract <= 1.0): 0.0 = the element is entirely above the free surface, 1.0 = element is entirely below the free surface and above the seabed (-)
   REAL(ReKi)                   :: DZFract                                         ! The fraction of the current tower element that is below the free surface of the incident wave and above the seabed (0.0 <= DZFract  <= 1.0): 0.0 = the element is entirely above the free surface, 1.0 = element is entirely below the free surface and above the seabed (-)
   REAL(ReKi)                   :: DZFractS                                        ! The fraction of the current tower element that is                                                 above the seabed (0.0 <= DZFractS <= 1.0): 0.0 = the element is entirely below the seabed      , 1.0 = element is entirely                            above the seabed (-)
   REAL(ReKi)                   :: DZFractW                                        ! The fraction of the current tower element that is below the free surface of the incident wave                      (0.0 <= DZFractW <= 1.0): 0.0 = the element is entirely above the free surface, 1.0 = element is entirely below the free surface                      (-)
   REAL(ReKi)                   :: InertiaForce     (2)                            ! Wave inertia force in the xi- (1) and yi- (2) directions, respectively, on the current tower element at the current time (N)
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   REAL(ReKi)                   :: MagVRel                                         ! The magnitude of the horizontal incident wave velocity relative to the current tower node at the current time (m/s)
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
   REAL(ReKi)                   :: MomArm                                          ! Moment arm in the vertical direction from the current tower node to the center of pressure of the wave load on the current tower element (meters)
   REAL(ReKi)                   :: TowerAM                                         ! Force -translation                     component of TwrAM (kg    /m)
   REAL(ReKi)                   :: TowerAMM                                        ! Force -rotation and moment-translation component of TwrAM (kg-m  /m)
   REAL(ReKi)                   :: TowerAMM2                                       !                     Moment-rotation    component of TwrAM (kg-m^2/m)
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   REAL(ReKi)                   :: TwrArea                                         ! Cross-sectional area of current tower element (m^2)
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remove6.02c   REAL(ReKi)                   :: WaveAcceleration0(3)                            ! Acceleration of incident waves in the xi- (1), yi- (2), and zi- (3) directions, respectively, at the current tower node and time (m/s^2)
   REAL(ReKi)                   :: TwrVelocity      (2)                            ! Velocity of the center of pressure of the wave load on the current tower element in the xi- (1) and yi- (2) directions, respectively, at the current time (m/s)
   REAL(ReKi)                   :: ViscousForce     (2)                            ! Viscous drag force in the xi- (1) and yi- (2) directions, respectively, on the current tower element at the current time (N)
   REAL(ReKi)                   :: WaveAcceleration0(2)                            ! Acceleration of incident waves in the xi- (1) and yi- (2) directions, respectively, at the current tower node and time (m/s^2)
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   REAL(ReKi)                   :: WaveElevation0                                  ! Elevation of incident waves at the platform reference point and current time (meters)
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remove6.02c   REAL(ReKi)                   :: WaveVelocity0    (3)                            ! Velocity     of incident waves in the xi- (1), yi- (2), and zi- (3) directions, respectively, at the current tower node and time (m/s  )
   REAL(ReKi)                   :: WaveVelocity0    (2)                            ! Velocity     of incident waves in the xi- (1) and yi- (2) directions, respectively, at the current tower node and time (m/s  )
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.

   INTEGER(4)                   :: K                                               ! Generic index


!bjj start of propsoed change v6.02d
!rm      ! Global functions:
!rm
!rm   CHARACTER(11), EXTERNAL      :: Int2LStr                                        ! A function to convert an interger to a left-justified string.
!bjj end of proposed change


      ! Initialize the added mass matrix per unit length of the current tower
      !   element, TwrAM, and the portion of the current tower element load per
      !   unit length associated with everything but the added mass effects,
      !   TwrFt, to zero:

   TwrAM(1,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
   TwrAM(2,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
   TwrAM(3,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
   TwrAM(4,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
   TwrAM(5,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
   TwrAM(6,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)

   TwrFt(1)   = 0.0
   TwrFt(2)   = 0.0
   TwrFt(3)   = 0.0
   TwrFt(4)   = 0.0
   TwrFt(5)   = 0.0
   TwrFt(6)   = 0.0



      ! Find the fraction of the current tower element that is below the free
      !   surface of the incident wave and above the seabed:

   IF ( WaveStMod == 0 )  THEN   ! .TRUE. if we have no stretching; therefore, integrate up to the MSL, regardless of the instantaneous free surface elevation.

      IF (     ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) >= 0.0            )  THEN ! .TRUE. if the current tower element lies entirely above the MSL.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = 0.0
         DZFractW = 0.0
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
      ELSEIF ( ( WaveKinzi0(JNode) + 0.5*DZNodes(JNode) ) <= 0.0            )  THEN ! .TRUE. if the current tower element lies entirely below the MSL.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = 1.0
         DZFractW = 1.0
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
      ELSE                                                                          ! The free surface of the incident wave must fall somewhere along the current tower element; thus, interpolate.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = ( ( 0.0            - ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) )/DZNodes(JNode) )
         DZFractW = ( ( 0.0            - ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) )/DZNodes(JNode) )
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
      ENDIF

   ELSE                          ! We must have some sort of stretching.

      WaveElevation0 = WaveElevation ( 1, ZTime )

      IF (     ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) >= WaveElevation0 )  THEN ! .TRUE. if the current tower element lies entirely above the free surface of the incident wave.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = 0.0
         DZFractW = 0.0
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
      ELSEIF ( ( WaveKinzi0(JNode) + 0.5*DZNodes(JNode) ) <= WaveElevation0 )  THEN ! .TRUE. if the current tower element lies entirely below the free surface of the incident wave.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = 1.0
         DZFractW = 1.0
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
      ELSE                                                                          ! The free surface of the incident wave must fall somewhere along the current tower element; thus, interpolate.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = ( ( WaveElevation0 - ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) )/DZNodes(JNode) )
         DZFractW = ( ( WaveElevation0 - ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) )/DZNodes(JNode) )
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
      ENDIF

   ENDIF

   IF (        ( WaveKinzi0(JNode) - 0.5*DZNodes(JNode) ) >= -WtrDpth       )  THEN ! .TRUE. if the current tower element lies entirely above the seabed.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = 1.0*DZFract
         DZFractS = 1.0
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   ELSEIF (    ( WaveKinzi0(JNode) + 0.5*DZNodes(JNode) ) <= -WtrDpth       )  THEN ! .TRUE. if the current tower element lies entirely below the seabed.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = 0.0*DZFract
         DZFractS = 0.0
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   ELSE                                                                             ! The seabed must fall somewhere along the current tower element; thus, interpolate.
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remmove6.02c         DZFract = ( ( ( WaveKinzi0(JNode) + 0.5*DZNodes(JNode) ) - ( -WtrDpth )   )/DZNodes(JNode) )*DZFract
         DZFractS = ( ( ( WaveKinzi0(JNode) + 0.5*DZNodes(JNode) ) - ( -WtrDpth )   )/DZNodes(JNode) )
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.
   ENDIF
!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:

   DZFract = DZFractW*DZFractS
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.



      ! Compute the hydrodynamic loads using Morison's equation for the portion of
      !   the current tower element that lies below the free surface of the
      !   incident wave and above the seabed:

   IF ( DZFract > 0.0 )  THEN ! .TRUE. if a portion of the current tower element lies below the free surface of the incident wave.


!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remove6.02c      ! Compute the velocity and acceleration of the incident waves in the
!remove6.02c      !   xi- (1), yi- (2), and zi- (3) directions, respectively, at the current
!remove6.02c      !   tower node and time:
!remove6.02c
!remove6.02c      DO K = 1,3     ! Loop through all xi- (1), yi- (2), and zi- (3) directions
!remove6.02c         WaveVelocity0    (K) = WaveVelocity     ( JNode, K, ZTime )
!remove6.02c         WaveAcceleration0(K) = WaveAcceleration ( JNode, K, ZTime )
!remove6.02c      ENDDO          ! K - All xi- (1), yi- (2), and zi- (3) directions
!remove6.02c
!remove6.02c
!remove6.02c      ! Compute the magnitude of the horizontal incident wave velocity relative to
!remove6.02c      !   the current tower node at the current time:
!remove6.02c
!remove6.02c      MagVRel = SQRT(   ( WaveVelocity0(1) - XD(1) )**2 &
!remove6.02c                      + ( WaveVelocity0(2) - XD(2) )**2   )
      ! Compute the moment arm in the vertical direction between the current tower
      !   node and the center of pressure of the wave load on the current tower
      !   element:

      MomArm = 0.5*DZNodes(JNode)*( DZFractW - DZFractS )   ! NOTE: MomArm = 0.0 when the entire element is submerged in the fluid; consequently, the roll and pitch components of the load are zero when the entire element is submerged in the fluid


      ! Compute the velocity and acceleration of the incident waves in the xi- (1)
      !   and yi- (2) directions, respectively, at the current tower node and
      !   time:

      DO K = 1,2     ! Loop through the xi- (1) and yi- (2) directions
         WaveVelocity0    (K) = WaveVelocity     ( JNode, K, ZTime )
         WaveAcceleration0(K) = WaveAcceleration ( JNode, K, ZTime )
      ENDDO          ! K - The xi- (1) and yi- (2) directions


      ! Compute the velocity of the center of pressure of the wave load on the
      !   current tower element in the xi- (1) and yi- (2) directions,
      !   respectively, at the current time:

      TwrVelocity(1) = XD(1) + XD(5)*MomArm
      TwrVelocity(2) = XD(2) - XD(4)*MomArm


      ! Compute the magnitude of the horizontal incident wave velocity relative to
      !   the center of pressure of the wave load on the current tower element at
      !   the current time:

      MagVRel = SQRT(   ( WaveVelocity0(1) - TwrVelocity(1) )**2 &
                      + ( WaveVelocity0(2) - TwrVelocity(2) )**2   )
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.


      ! Compute the cross-sectional area of the current tower element:

      TwrArea = PiOvr4*TwrDiam*TwrDiam


!jmj Start of proposed change.  v6.02c-jmj  02-Feb-2007.
!jmj Improve the calculations for hydrodynamic loading on a monopile:  If the
!jmj   current tower element is only partially-covered by fluid, in addition to
!jmj   the force, compute a moment on the tower element to correct for the fact
!jmj   that the force is applied only to a portion of the tower element:
!remove6.02c      DO K = 1,2     ! Loop through the xi- (1) and yi- (2) directions
!remove6.02c
!remove6.02c
!remove6.02c      ! Compute the added mass matrix per unit length of the current tower
!remove6.02c      !   element:
!remove6.02c
!remove6.02c         TwrAM(K,K) = TwrAM(K,K) + TwrCA*WtrDens*TwrArea*DZFract
!remove6.02c
!remove6.02c
!remove6.02c      ! Compute the portion of the current tower element load per unit length
!remove6.02c      !   associated with the incident wave acceleration:
!remove6.02c
!remove6.02c         TwrFt(K  ) = TwrFt(K  ) + ( 1.0 + TwrCA )*WtrDens*TwrArea*WaveAcceleration0(K)*DZFract
!remove6.02c
!remove6.02c
!remove6.02c      ! Compute the portion of the current tower element load per unit length
!remove6.02c      !   associated with the viscous drag:
!remove6.02c
!remove6.02c         TwrFt(K  ) = TwrFt(K  ) + 0.5*TwrCD*WtrDens*TwrDiam*( WaveVelocity0(K) - XD(K) )*MagVRel*DZFract
!remove6.02c
!remove6.02c
!remove6.02c      ENDDO          ! K - The xi- (1) and yi- (2) directions
      ! Compute the added mass matrix per unit length of the current tower
      !   element:

      TowerAM    = TwrCA*WtrDens*TwrArea*DZFract   ! force -translation                     component
      TowerAMM   = TowerAM *MomArm                 ! force -rotation and moment-translation component
      TowerAMM2  = TowerAMM*MomArm                 !                     moment-rotation    component

      TwrAM(1,1) = TwrAM(1,1) + TowerAM   ! surge-surge component
      TwrAM(2,2) = TwrAM(2,2) + TowerAM   ! sway -sway  component
      TwrAM(4,4) = TwrAM(4,4) + TowerAMM2 ! roll -roll  component
      TwrAM(5,5) = TwrAM(5,5) + TowerAMM2 ! pitch-pitch component
      TwrAM(2,4) = TwrAM(2,4) - TowerAMM  ! sway -roll  component
      TwrAM(4,2) = TwrAM(4,2) - TowerAMM  ! roll -sway  component
      TwrAM(1,5) = TwrAM(1,5) + TowerAMM  ! surge-pitch component
      TwrAM(5,1) = TwrAM(5,1) + TowerAMM  ! pitch-surge component


      ! Compute the portions of the current tower element load per unit length
      !   associated with the incident wave acceleration and the viscous drag:

      DO K = 1,2     ! Loop through the xi- (1) and yi- (2) directions
         InertiaForce(K) = ( 1.0 + TwrCA )*WtrDens*TwrArea*WaveAcceleration0(K)*DZFract
         ViscousForce(K) = 0.5*TwrCD*WtrDens*TwrDiam*( WaveVelocity0(K) - TwrVelocity(K) )*MagVRel*DZFract
      ENDDO          ! K - The xi- (1) and yi- (2) directions

      TwrFt(1  ) = TwrFt(1  ) +   InertiaForce(1) + ViscousForce(1)           ! surge component
      TwrFt(2  ) = TwrFt(2  ) +   InertiaForce(2) + ViscousForce(2)           ! sway  component
      TwrFt(4  ) = TwrFt(4  ) - ( InertiaForce(2) + ViscousForce(2) )*MomArm  ! roll  component
      TwrFt(5  ) = TwrFt(5  ) + ( InertiaForce(1) + ViscousForce(1) )*MomArm  ! pitch component
!jmj End of proposed change.  v6.02c-jmj  02-Feb-2007.


   ENDIF



   RETURN
   END SUBROUTINE MorisonTwrLd
!=======================================================================
!bjj start of proposed change
   SUBROUTINE FB_Terminate( )
   
   ! Deallocate arrays
   
   
   
   ! close files
   
   END SUBROUTINE FB_Terminate

!=======================================================================
!bjj end of proposed change
END MODULE FixedBottomSupportStructure
!=======================================================================
!BJJ start of proposed change
MODULE HydroDyn

   USE NWTC_Library
   
   IMPLICIT NONE
   
CONTAINS

   SUBROUTINE Hydro_Terminate ( )
   
      USE         Waves,                       ONLY: Wave_Terminate
      USE         FloatingPlatform,            ONLY: FP_Terminate
      USE         FixedBottomSupportStructure, ONLY: FB_Terminate
   
   
      CALL Wave_Terminate()
      CALL FP_Terminate()
      CALL FB_Terminate()
   
   END SUBROUTINE Hydro_Terminate

END MODULE HydroDyn
!bjj end of proposed change
!JASON: MOVE THIS USER-DEFINED ROUTINE (UserTwrLd) TO THE UserSubs.f90 OF FAST WHEN THE MONOPILE LOADING FUNCTIONALITY HAS BEEN DOCUMENTED!!!!!
SUBROUTINE UserTwrLd ( JNode, X, XD, ZTime, DirRoot, TwrAM, TwrFt )


   ! This is a dummy routine for holding the place of a user-specified
   ! tower loading model.  Modify this code to create your own model.
   ! The local variables and associated calculations below provide a
   ! template for making this user-specified tower loading model
   ! include linear 6x6 damping and stiffness matrices.  These are
   ! provided as an example only and can be modified or deleted as
   ! desired by the user without detriment to the interface (i.e., they
   ! are not necessary for the interface).

   ! The tower loads returned by this routine should contain contributions from
   !   any external load acting on the current tower element (indicated by
   !   JNode) other than loads transmitted from tower aerodynamics.  For
   !   example, these tower forces should contain contributions from foundation
   !   stiffness and damping [not floating] or mooring line/guy wire restoring
   !   and damping, as well as hydrostatic and hydrodynamic contributions
   !   [offshore].

   ! This routine assumes that the tower loads are transmitted through a medium
   !   like soil [foundation] and/or water [offshore], so that added mass
   !   effects are important.  Consequently, the routine assumes that the total
   !   load per unit length on the current tower element can be written as:
   !
   ! TwrF(i) = SUM( -TwrAM(i,j)*XDD(j), j=1,2,..,6) + TwrFt(i) for i=1,2,...,6
   !
   ! where,
   !   TwrF(i)    = the i'th component of the total load per unit length
   !                applied on the current tower element; positive in the
   !                direction of positive motion of the i'th DOF of the current
   !                tower element
   !   TwrAM(i,j) = the (i,j) component of the tower added mass matrix per unit
   !                length (output by this routine)
   !   XDD(j)     = the j'th component of the current tower element
   !                acceleration vector
   !   TwrFt(i)   = the i'th component of the portion of the current tower
   !                element load per unit length associated with everything but
   !                the added mass effects; positive in the direction of
   !                positive motion of the i'th DOF of the current tower
   !                element (output by this routine)

   ! The order of indices in all arrays passed to and from this routine is as
   !   follows:
   !      1 = Current tower element surge / xi-component of translation
   !      3 = Current tower element sway  / yi-component of translation
   !      3 = Current tower element heave / zi-component of translation
   !      4 = Current tower element roll  / xi-component of rotation
   !      5 = Current tower element pitch / yi-component of rotation
   !      6 = Current tower element yaw   / zi-component of rotation

   ! NOTE: The added mass matrix returned by this routine, TwrAM, must be
   !       symmetric.  FAST and ADAMS will abort otherwise.
   !
   !       Please also note that the hydrostatic restoring contribution to the
   !       hydrodynamic force returned by this routine should not contain the
   !       effects of body weight, as is often done in classical marine
   !       hydrodynamics.  The effects of body weight are included within FAST
   !       and ADAMS.

!bjj start of proposed change
!rmUSE                             Precision
USE                             NWTC_Library
!bjj end of proposed change

IMPLICIT                        NONE


   ! Passed Variables:

REAL(ReKi), INTENT(OUT)      :: TwrAM  (6,6)                                    ! Added mass matrix per unit length of current tower element, kg/m, kg-m/m, kg-m^2/m.
REAL(ReKi), INTENT(OUT)      :: TwrFt    (6)                                    ! The surge/xi (1), sway/yi (2), and heave/zi (3)-components of the portion of the tower force per unit length (in N/m) at the current tower element and the roll/xi (4), pitch/yi (5), and yaw/zi (6)-components of the portion of the tower moment per unit length (in N-m/m) acting at the current tower element associated with everything but the added-mass effects; positive forces are in the direction of motion.
REAL(ReKi), INTENT(IN )      :: X        (6)                                    ! The 3 components of the translational displacement (in m  ) of the current tower node and the 3 components of the rotational displacement       (in rad  ) of the current tower element relative to the inertial frame origin at ground level [onshore] or MSL [offshore].
REAL(ReKi), INTENT(IN )      :: XD       (6)                                    ! The 3 components of the translational velocity     (in m/s) of the current tower node and the 3 components of the rotational (angular) velocity (in rad/s) of the current tower element relative to the inertial frame origin at ground level [onshore] or MSL [offshore].
REAL(ReKi), INTENT(IN )      :: ZTime                                           ! Current simulation time, sec.

INTEGER(4), INTENT(IN )      :: JNode                                           ! The number of the current tower node / element, (-). [1 to TwrNodes]

CHARACTER(1024), INTENT(IN ) :: DirRoot                                         ! The name of the root file including the full path to the current working directory.  This may be useful if you want this routine to write a permanent record of what it does to be stored with the simulation results: the results should be stored in a file whose name (including path) is generated by appending any suitable extension to DirRoot.


   ! Local Variables:

REAL(ReKi)                   :: Damp   (6,6)                                    ! Damping matrix.
REAL(ReKi)                   :: Stff   (6,6)                                    ! Stiffness/restoring matrix.

INTEGER(4)                   :: I                                               ! Generic index.
INTEGER(4)                   :: J                                               ! Generic index.



Damp (1,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Damp (2,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Damp (3,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Damp (4,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Damp (5,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Damp (6,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)

Stff (1,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Stff (2,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Stff (3,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Stff (4,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Stff (5,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
Stff (6,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)

TwrAM(1,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
TwrAM(2,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
TwrAM(3,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
TwrAM(4,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
TwrAM(5,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)
TwrAM(6,:) = (/ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /)

TwrFt(1)   = 0.0
TwrFt(2)   = 0.0
TwrFt(3)   = 0.0
TwrFt(4)   = 0.0
TwrFt(5)   = 0.0
TwrFt(6)   = 0.0

DO J = 1,6
   DO I = 1,6
      TwrFt(I) = TwrFt(I) - Damp(I,J)*XD(J) - Stff(I,J)*X(J)
   ENDDO
ENDDO



RETURN
END SUBROUTINE UserTwrLd
!=======================================================================
!jmj End of proposed change.  v6.02a-jmj  25-Aug-2006.
