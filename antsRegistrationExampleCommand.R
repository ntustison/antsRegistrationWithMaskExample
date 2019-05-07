library( ANTsR)

# Read in the images

dataDirectory <- './InputData/'

fixedImage <- antsImageRead(
   paste0( dataDirectory, 'r16sliceWithCircle.nii.gz' ), dimension = 2 )
fixedMask <- antsImageRead(
   paste0( dataDirectory, 'r16mask.nii.gz' ), dimension = 2 )
movingImage <- antsImageRead(
   paste0( dataDirectory, 'r64sliceWithSquare.nii.gz' ), dimension = 2 )
movingMask <- antsImageRead(
   paste0( dataDirectory, 'r64mask.nii.gz' ), dimension = 2 )

# Plot the fixed image/mask
plot( fixedImage, fixedMask, color.overlay = "jet", alpha = 0.7 )

# Plot the moving image/mask
plot( movingImage, movingMask, color.overlay = "jet", alpha = 0.7 )

#######
#
# Perform registration with no mask
#

outputDirectory <- './OutputNoMaskANTsR/'
if( ! dir.exists( outputDirectory ) )
  {
  dir.create( outputDirectory )
  }
outputPrefix <- paste0( outputDirectory, 'antsr' )

registrationNoMask <- antsRegistration(
  fixed = fixedImage, moving = movingImage,
  typeOfTransform = "SyNOnly",
  regIterations = c( 100, 75, 20, 0 ),
  verbose = TRUE, outprefix = outputPrefix )

antsImageWrite( registrationNoMask$warpedmovout, paste0( outputPrefix, "Warped.nii.gz" ) )
antsImageWrite( registrationNoMask$warpedfixout, paste0( outputPrefix, "InverseWarped.nii.gz" ) )

# Plot the fixed and warped moving image
plot( fixedImage, registrationNoMask$warpedmovout, color.overlay = "jet", alpha = 0.4 )

# Plot the moving and warped fixed image
plot( movingImage, registrationNoMask$warpedfixout, color.overlay = "jet", alpha = 0.4 )

jacobian <- createJacobianDeterminantImage( fixedImage, registrationNoMask$fwdtransforms[1] )
plot( jacobian )

#######
#
# Perform registration with mask
#

outputDirectory <- './OutputWithMaskANTsR/'
if( ! dir.exists( outputDirectory ) )
  {
  dir.create( outputDirectory )
  }
outputPrefix <- paste0( outputDirectory, 'antsr' )

registrationWithMask <- antsRegistration(
  fixed = fixedImage, moving = movingImage,
  mask = list( fixedMask, movingMask ),
  typeOfTransform = "SyNOnly",
  regIterations = c( 100, 75, 20, 0 ),
  verbose = TRUE, outprefix = outputPrefix )

antsImageWrite( registrationNoMask$warpedmovout, paste0( outputPrefix, "Warped.nii.gz" ) )
antsImageWrite( registrationNoMask$warpedfixout, paste0( outputPrefix, "InverseWarped.nii.gz" ) )

# Plot the fixed and warped moving image
plot( fixedImage, registrationWithMask$warpedmovout, color.overlay = "jet", alpha = 0.4 )

# Plot the moving and warped fixed image
plot( movingImage, registrationWithMask$warpedfixout, color.overlay = "jet", alpha = 0.4 )

jacobian <- createJacobianDeterminantImage( fixedImage, registrationWithMask$fwdtransforms[1] )
plot( jacobian )
