from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json
from inference_sdk import InferenceHTTPClient
import time
from django.conf import settings
from django.core.files.storage import FileSystemStorage
import base64

def home(request):
    return HttpResponse("Welcome to the home page!")
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

@csrf_exempt
def posthand(request):
    """
    user makes post request to store their hand
    """
    if request.method != 'POST':
        return HttpResponse(status=400)
    
    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filepath = fs.save(filename, content)
        imageurl = fs.url(filename)
    else:
        return HttpResponse(status=400)
     
    CLIENT = InferenceHTTPClient(
        api_url="https://detect.roboflow.com",
        api_key="l6SJyHjHh6vPwwwD6Uhd"
    )
    
    result = CLIENT.infer('media/'+filename, model_id='playing-cards-ow27d/4')    
    cards = []
    insert_sql = """
    INSERT INTO userhands (imageurl, cards) VALUES (%s, %s);
    """
    cursor = connection.cursor()
    # create new db for user hands
    cursor.execute('CREATE TABLE IF NOT EXISTS userhands (id SERIAL PRIMARY KEY, imageurl TEXT, cards TEXT);')
    cursor.execute('TRUNCATE TABLE userhands;')

    for card in result['predictions']:
        if card['class'] not in cards:
            cards.append(card['class'])
            cursor.execute(insert_sql, (imageurl, card['class']))
    

    return JsonResponse({
        # "imageurl": imageurl,
        # "cards": cards,
        # "message": "success"    
    })

def gethand(request):
    """
    user makes get request to retrieve their hand
    """
    if request.method != 'GET':
        return HttpResponse(status=400)
    
    cursor = connection.cursor()
    cursor.execute('SELECT cards FROM userhands ORDER BY id DESC;')
    rows = cursor.fetchall()
    cards = [row[0] for row in rows]
    response = {}
    response['cards'] = cards
    return JsonResponse(response)

@csrf_exempt
def postcommunitycards(request):
    """
    user makes post request to store community cards
    """
    if request.method != 'POST':
        return HttpResponse(status=400)
    
    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filepath = fs.save(filename, content)
        imageurl = fs.url(filename)
    else:
        return HttpResponse(status=400)
     
    CLIENT = InferenceHTTPClient(
        api_url="https://detect.roboflow.com",
        api_key="l6SJyHjHh6vPwwwD6Uhd"
    )
    
    result = CLIENT.infer('media/'+filename, model_id='playing-cards-ow27d/4')    
    cards = []
    insert_sql = """
    INSERT INTO communitycards (imageurl, cards) VALUES (%s, %s);
    """
    cursor = connection.cursor()
    # create new db for user hands
    cursor.execute('CREATE TABLE IF NOT EXISTS communitycards (id SERIAL PRIMARY KEY, imageurl TEXT, cards TEXT);')
    cursor.execute('TRUNCATE TABLE communitycards;')
    for card in result['predictions']:
        if card['class'] not in cards:
            cards.append(card['class'])
            cursor.execute(insert_sql, (imageurl, card['class']))
    

    return JsonResponse({
        # "imageurl": imageurl,
        # "cards": cards,
        # "message": "success"    
    })

def getcommunitycards(request):
    """
    user makes get request to retrieve community cards
    """
    if request.method != 'GET':
        return HttpResponse(status=400)
    
    cursor = connection.cursor()
    cursor.execute('SELECT cards FROM communitycards ORDER BY id DESC;')
    rows = cursor.fetchall()
    cards = [row[0] for row in rows]
    response = {}
    response['cards'] = cards
    return JsonResponse(response)

@csrf_exempt
def getmoney(request):
    """
    user makes get request to retrieve community cards
    """
    if request.method != 'GET':
        return HttpResponse(status=400)
    
    cursor = connection.cursor()
    cursor.execute('SELECT useramount, callamount FROM usermoney ORDER BY id DESC;')
    rows = cursor.fetchall()
    usermoney = [row[0] for row in rows]
    callamount = [row[1] for row in rows]
    response = {}
    response['useramount'] = usermoney
    response['callamount'] = callamount
    return JsonResponse(response)

@csrf_exempt
def postmoney(request):
    """
    user makes post request to store their money
    """
    if request.method != 'POST':
        return HttpResponse(status=400)

    json_data = json.loads(request.body)
    
    useramount = json_data.get("useramount")
    callamount = json_data.get("callamount")
    
    if useramount and callamount:
        cursor = connection.cursor()
        cursor.execute('CREATE TABLE IF NOT EXISTS usermoney (id SERIAL PRIMARY KEY, useramount TEXT, callamount TEXT);')
        cursor.execute('TRUNCATE TABLE usermoney;')
        cursor.execute('INSERT INTO usermoney (useramount, callamount) VALUES (%s, %s);', (useramount, callamount))

    return JsonResponse({})

@csrf_exempt
def postfinalhand(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    response = json_data['cards']
    cards = response.split(', ')

    cursor = connection.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS userfinalhands (cards TEXT);')
    cursor.execute('TRUNCATE TABLE userfinalhands;')

    for card in cards:
        cursor.execute('INSERT INTO userfinalhands (cards) VALUES '
                   '(%s);', (card,))

    return JsonResponse({})

@csrf_exempt
def postfinalcommunitycards(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    response = json_data['cards']
    cards = response.split(', ')

    cursor = connection.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS finalcommunitycards (cards TEXT);')
    cursor.execute('TRUNCATE TABLE finalcommunitycards;')

    for card in cards:
        cursor.execute('INSERT INTO finalcommunitycards (cards) VALUES '
                   '(%s);', (card,))

    return JsonResponse({})

@csrf_exempt
def getfinalhand(request):
    """
    user makes get request to retrieve their final hand
    """
    if request.method != 'GET':
        return HttpResponse(status=400)
    
    cursor = connection.cursor()
    cursor.execute('SELECT cards FROM userfinalhands;')
    rows = cursor.fetchall()
    cards = [row[0] for row in rows]
    response = {}
    response['cards'] = cards
    return JsonResponse(response)

@csrf_exempt
def getfinalcommunitycards(request):
    """
    user makes get request to retrieve final community cards
    """
    if request.method != 'GET':
        return HttpResponse(status=400)
    
    cursor = connection.cursor()
    cursor.execute('SELECT cards FROM finalcommunitycards;')
    rows = cursor.fetchall()
    cards = [row[0] for row in rows]
    response = {}
    response['cards'] = cards
    return JsonResponse(response)
