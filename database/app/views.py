from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
from inference_sdk import InferenceHTTPClient


def getchatts(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    cursor = connection.cursor()
    cursor.execute('SELECT username, message, time FROM chatts ORDER BY time DESC;')
    rows = cursor.fetchall()

    response = {}
    response['chatts'] = rows
    return JsonResponse(response)

@csrf_exempt
def postchatt(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    username = json_data['username']
    message = json_data['message']

    cursor = connection.cursor()
    cursor.execute('INSERT INTO chatts (username, message) VALUES '
                   '(%s, %s);', (username, message))

    return JsonResponse({})

def posthand(request):
    """
    user makes post request to store their hand
    """
    CLIENT = InferenceHTTPClient(
        api_url="https://detect.roboflow.com",
        api_key="mWSb39hdm6MVvx23Kwu6"
    )   

    result = CLIENT.infer("/content/IMG_5401.JPG", model_id="playing-cards-ow27d/4")    


# Create your views here.
