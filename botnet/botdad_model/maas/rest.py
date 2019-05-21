import json
import model
from flask import Flask
from flask import request,jsonify
import socket
import numpy as np

app = Flask(__name__)

@app.route("/apply", methods=['GET'])
def predict():
  # there should be 15 double features p1 - p15 
  request_features = []
  for feature_id in range(15):
     arg_name = "p{}".format(feature_id + 1) 
     request_features.insert(feature_id, float(request.args.get(arg_name)))
  print(request_features)
  r = {}
  r['bot_prediction'] = model.evaluate_request(np.array([ request_features ]))

  # We will return a JSON map with one field, 'bot_prediction' which will be
  # 'clean' or 'bot', the two possible outputs of our model.
  return jsonify(r)

if __name__ == "__main__":
  # Create my model object that I want to expose.
  model = model.BOTDAD()
  # In order to register with model as a service, we need to bind to a port
  # and inform the discovery service of the endpoint. Therefore,
  # we will bind to a port and close the socket to reserve it.
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.bind(('localhost', 0))
  port = sock.getsockname()[1]
  sock.close()
  with open("endpoint.dat", "w") as text_file:
    # To inform the discovery service, we need to write a file with a simple
    # JSON Map indicating the full URL that we've bound to.
    text_file.write("{\"url\" : \"http://0.0.0.0:%d\"}" % port)
  # Make sure flask uses the port we reserved
  app.run(threaded=True, host="0.0.0.0", port=port)
