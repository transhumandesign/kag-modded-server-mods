//TreeDeeCameraClass.as

class Camera
{
	float[] matrix;
	//float CameraAngleX = 0.01f;
	//float CameraAngleY = 0.01f;
	//float CameraAngleZ = 0.01f;

	float LastCameraAngleX = 0.01f;
	float LastCameraAngleY = 0.01f;
	float LastCameraAngleZ = 0.01f;

	Camera(){}

	void MoveCamera(float _CameraAngleX, float _CameraAngleY, float _CameraAngleZ)
	{
		LastCameraAngleX = _CameraAngleX;
		LastCameraAngleY = _CameraAngleY;
		LastCameraAngleZ = _CameraAngleZ;
		
		float[] tempH;
		Matrix::MakeIdentity(tempH);
		Matrix::SetRotationDegrees(tempH, 0, _CameraAngleX, 0);
		
		float[] tempV;
		Matrix::MakeIdentity(tempV);
		Matrix::SetRotationDegrees(tempV, _CameraAngleY, 0, 0);
		
		float[] tempR;
		Matrix::MakeIdentity(tempR);
		Matrix::SetRotationDegrees(tempR, 0, 0, _CameraAngleZ);
		
		float[] tempCam = Multiply(tempV, tempR);
		//Matrix::MakeIdentity(tempCam);
		//tempCam = Multiply(tempV, tempR);
		
		//matrix 
		
		//float[] tempU;
		//Matrix::MakeIdentity(tempU);
		//Matrix::SetTranslation(tempU, 0, 10, 0);
		
		//float[] tempTCam = Multiply(tempCam, tempH);
		
		matrix = Multiply(tempCam, tempH);
	}
}

float[] Multiply(float[] first, float[] second)
{
	float[] new(16);
	for(int i = 0; i < 4; i++)
		for(int j = 0; j < 4; j++)
			for(int k = 0; k < 4; k++)
				new[i+j*4] += first[i+k*4] * second[j+k*4];
	return new;
}