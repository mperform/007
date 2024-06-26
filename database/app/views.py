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

import pied_poker as pp


def home(request):
    return HttpResponse("Welcome to the home page!")

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

csrf_exempt
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

@csrf_exempt
def getbesthand(request):
    """
    Return the best hand based on the cards stored in the database.
    """

    if request.method != 'GET':
        return HttpResponse(status=400)

    cursor = connection.cursor()
    cursor.execute('SELECT cards FROM finalcommunitycards;')
    comm_cards = [row[0] for row in cursor.fetchall()]
    cursor.execute('SELECT cards FROM userfinalhands;')
    user_hands = [row[0] for row in cursor.fetchall()]

    player = pp.Player('Player', pp.Card.of(*user_hands))
    community_cards = pp.Card.of(*(comm_cards)) if comm_cards[0] != '' 0 else []
    round_result = pp.PokerRound.PokerRoundResult([player], community_cards)

    best_hand = round_result.str_winning_hand()

    cursor.execute('CREATE TABLE IF NOT EXISTS besthand (hand TEXT);')
    cursor.execute('TRUNCATE TABLE besthand;')
    cursor.execute('INSERT INTO besthand (hand) VALUES '
                   '(%s);', (best_hand,))

    cursor.execute('SELECT numopponents FROM playerinfo')
    num_opponents = cursor.fetchall()[0][0]
    print(num_opponents)
    simulator = pp.PokerRound.PokerRoundSimulator(community_cards=community_cards,
                       players=[player],
                      total_players=(num_opponents+1))
    num_simulations = 5000
    simulation_result = simulator.simulate(n=num_simulations, n_jobs=1)

    hand_probs = {}
    for hand_type in reversed(pp.Hand.PokerHand.ALL_HANDS_RANKED):
        p = simulation_result.probability_of(pp.Probability.PlayerHasHand(hand_type, player))
        hand_probs[hand_type.__name__] = p.probability
        
    winning_probability = simulation_result.probability_of(pp.Probability.PlayerWins()).probability

    decision = ""
    if winning_probability > 0.9:
        decision = "GO ALL IN"
    elif winning_probability > 0.8:
        decision = "RAISE"
    elif winning_probability > 0.5:
        decision = "CALL"
    else:
        decision = "FOLD"

    cursor.execute('CREATE TABLE IF NOT EXISTS winprob (probability DECIMAL(5, 4), decision TEXT);')
    cursor.execute('TRUNCATE TABLE winprob;')
    cursor.execute('INSERT INTO winprob VALUES '
                   '(%s, %s);', (winning_probability, decision))

    response = {'best_hand': best_hand,
                'winning_probability': str(winning_probability),
                'decision': decision,
                'hand_probabilities': hand_probs
                }
    return JsonResponse(response)

csrf_exempt
def postplayerinfo(request):
    if request.method != 'POST':
        return HttpResponse(status=404)

    json_data = json.loads(request.body)
    num_players = json_data['numopponents']
    position = json_data['position']

    cursor = connection.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS playerinfo (numopponents INTEGER, position INTEGER);')

    cursor.execute('TRUNCATE TABLE playerinfo;')
    cursor.execute('INSERT INTO playerinfo (numopponents, position) VALUES (%s, %s);', (int(num_players), int(position)))

    return JsonResponse({})
