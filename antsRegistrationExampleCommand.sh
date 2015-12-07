# /usr/bin/sh

fixedImage=./InputData/r16sliceWithCircle.nii.gz
fixedMask=./InputData/r16mask.nii.gz
movingImage=./InputData/r64sliceWithSquare.nii.gz
movingMask=./InputData/r64mask.nii.gz

#######
#
# Do with no mask
#

outputDirectory=./OutputNoMask/

mkdir -p $outputDirectory

antsRegistration -d 2 -v 1 \
  -o [${outputDirectory}/ants,${outputDirectory}/antsWarped.nii.gz,${outputDirectory}/antsInverseWarped.nii.gz] \
  -r [${fixedMask},${movingMask},1] \
  -t SyN[0.1,3,0] \
  -c [100x75x20x0,0,10] \
  -m CC[${fixedImage},${movingImage},1,4] \
  -f 4x3x2x1 \
  -s 1x1x0x0

CreateJacobianDeterminantImage 2 ${outputDirectory}/ants1Warp.nii.gz ${outputDirectory}/ants1WarpJacobian.nii.gz

/Applications/ITK-SNAP.app/Contents/MacOS/ITK-SNAP -g $fixedImage -o ${outputDirectory}/antsWarped.nii.gz -s $fixedMask &

#######
#
# Do with mask
#

outputDirectory=./OutputWithMask/

mkdir -p $outputDirectory

antsRegistration -d 2 -v 1 \
  -o [${outputDirectory}/ants,${outputDirectory}/antsWarped.nii.gz,${outputDirectory}/antsInverseWarped.nii.gz] \
  -r [${fixedMask},${movingMask},1] \
  -t SyN[0.1,3,0] \
  -c [100x75x20x0,0,10] \
  -m CC[${fixedImage},${movingImage},1,4] \
  -f 4x3x2x1 \
  -s 1x1x0x0 \
  -x [${fixedMask},${movingMask}]

CreateJacobianDeterminantImage 2 ${outputDirectory}/ants1Warp.nii.gz ${outputDirectory}/ants1WarpJacobian.nii.gz

/Applications/ITK-SNAP.app/Contents/MacOS/ITK-SNAP -g $fixedImage -o ${outputDirectory}/antsWarped.nii.gz -s $fixedMask &
