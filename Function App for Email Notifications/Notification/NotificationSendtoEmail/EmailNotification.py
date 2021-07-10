import smtplib, ssl 
import base64
from azure.keyvault.secrets import SecretClient
from azure.identity import DefaultAzureCredential

def sendEmail(subject,receivers,sent_message):
    # keyVaultName = 'psaetlkeyvault'
    # KVUri = f"https://{keyVaultName}.vault.azure.net"

    # credential = DefaultAzureCredential()
    # client = SecretClient(vault_url=KVUri, credential=credential)

    base64_message = sent_message
    base64_bytes = base64_message.encode('ascii')
    message_bytes = base64.b64decode(base64_bytes)
    sent_message = message_bytes.decode('ascii')

    # retrieved_secret = client.get_secret('')
    sent_message = sent_message.replace('\n','<br/>')

    if 'fail' in subject.lower():
        color = 'red'
    elif 'success'in subject.lower() or 'succed' in subject.lower():
        color = 'green'
    else:
        color = 'black'

    port = 587
    user = "testserverforemail@gmail.com"
    smtp_server = "smtp.gmail.com"
    sender_email = "toptal.admin@gmail.com"
    password = 'jrcfjmjyklopjekv'

    message = '''Content-Type: text/html;
MIME-Version: 1.0
Subject: {subject}
From: toptal.admin@gmail.com
To: {receivers}

Hi Team,
<br/>
<br/>
Please find the details below.
<br/>
<b style="color:{color};">{sent_message}</b>
<br/>
<br/>
Regards,<br/>
Toptal Team<br/><br/>
<font size="1">This is a system generated email, do not reply to this email id.</font>
'''.format(subject=subject,color=color,sent_message=sent_message,receivers=receivers)
    try:
        context = ssl.create_default_context()
        with smtplib.SMTP(smtp_server, port) as server:
            server.ehlo() 
            server.starttls(context=context)
            server.ehlo()
            server.login(user, password)
            server.sendmail(sender_email, receivers, message)
        return True,'''Sent an email to the following Email Id's: {receivers}'''.format(receivers=receivers)
    except Exception as E:
        return False,str(E)

