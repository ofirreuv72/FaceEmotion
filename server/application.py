from flask import Flask
from flask import request
from flask import jsonify

import requests 
app = Flask(__name__)

@app.route('/echo', methods = ['GET'])
def echo():
	return "Hello"


@app.route('/face', methods = ['POST'])
def api_message():
	if request.headers['Content-Type'] == 'application/octet-stream':
		URL = "https://orfaceapi.cognitiveservices.azure.com/face/v1.0/detect"
		PARAMS = {'returnFaceId':'true','returnFaceAttributes':'emotion','returnFaceLandmarks':'false','recognitionModel':'recognition_01','returnRecognitionModel':'false','detectionModel':'detection_01','returnFaceId':'true'}
		headers = {'Ocp-Apim-Subscription-Key':'386f1ee9f07a4278ba6440ad9db80580','Content-Type': 'application/octet-stream'}
		r = requests.post(url = URL, params = PARAMS , data = request.data, headers = headers) 
		data = r.json() 
		return jsonify(data)
	else:
		return "415 Unsupported Media Type ;)"
