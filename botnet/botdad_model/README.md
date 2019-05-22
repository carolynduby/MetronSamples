# BotDAD model rest service

The BotDAD model used was provided in the notebook below by ManmeetSing, Maninder Singh, and Sanmeet Kaura.   

I modified the notebook to save the file to a pickle file using joblib.  I then created a rest service that loads the file and returns predictions.

```
joblib.dump(self.rf_classifier, model_file_name)
```

The original notebook provided by the authors is [https://github.com/mannirulz/BotDAD/blob/master/ML/BotDAD.ipynb]

----------------------
 References
-----------------------

1. Singh M, Singh M, Kaur S (2018) Detecting bot-infected machines using DNS fingerprinting. Digit Investig 28:14–33 . doi: 10.1016/j.diin.2018.12.005
