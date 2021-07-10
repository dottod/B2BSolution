import logging
import json
import azure.functions as func
from .intrim import FunctionApp

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('The FunctionApp is Up and Running.')
    try:
        data = dict(req.get_json())
        try:
            returnedObj = FunctionApp(data['FunctionName'],data['Data'])
        except Exception as E:
            returnedObj = False, str(E)
    except Exception as E:
        returnedObj= False, str(E)
    finally:            
        return func.HttpResponse(
            body = json.dumps({'executed':returnedObj[0],'body':returnedObj[1]})
        )   
