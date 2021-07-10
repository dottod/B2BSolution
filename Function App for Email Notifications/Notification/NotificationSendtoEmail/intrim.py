from .EmailNotification import sendEmail


def FunctionApp(functionName,data):
    print(functionName,type(data))
    if functionName=='Email':
        subject = data['Subject']
        receivers = data['Receivers']
        sent_message = data['Message']
        returnedObj = sendEmail(subject,receivers,sent_message)
    elif functionName=='Pipeline':    
        return True,'In Progress'
    else:
        return False,'Invalid Function Name Passed.'
    return returnedObj