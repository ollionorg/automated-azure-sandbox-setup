import logging
import requests
import json
import base64
import subprocess
import argparse
import os
import csv

def gsuite_generate_outh_token():
    try:
        bash_command = ["token", "-email", GSUITE_ADMIN_EMAIL, "-file", GSUITE_CREDS, "-scope", "https://www.googleapis.com/auth/admin.directory.user.readonly"]
        process = subprocess.Popen(bash_command, stdout=subprocess.PIPE)
        outh_token, error = process.communicate()
    except Exception as e:
        logging.error(f"While Generating oauth token: {str(e)}")
        exit(1)
    else:
        return outh_token.decode().strip()

def gsuite_get_users(headers):

    # OBJECT FORMAT: gsuite_users --> { "useremail": "objectid", ...} ; gsuite_groups --> { "groupemail": "objectid,groupname" , ...}
    gsuite_users = {}
    gsuite_user_url = f"https://admin.googleapis.com/admin/directory/v1/users/{USER_EMAIL}"


    response = requests.request("GET", gsuite_user_url, headers=headers, data={})
    user_obj = json.loads(response.text)
    if response.status_code == 200:
        if user_obj["suspended"] == False and user_obj["archived"] == False and user_obj["primaryEmail"].split("@")[1] == "domain_name":
                    gsuite_users[user_obj["primaryEmail"]] = user_obj["name"]["fullName"]


    else:
     print("Email ID not found")
     exit(1)
    return gsuite_users


example_message = '''Example:
python3 google-workspace-validate-users.py "google_auth_email_id "./credentials.json" "input email id of user" '''
parser = argparse.ArgumentParser(description=" Google workspace users", epilog=example_message, formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument("email", help="Google workspace admin email", type=str)
parser.add_argument("credentials_file", help="Google workspace credentials file path", type=str)
parser.add_argument("username", help="Google workspace username", type=str)
args = parser.parse_args()

GSUITE_ADMIN_EMAIL = args.email
GSUITE_CREDS = args.credentials_file
GSUITE_OAUTH_TOKEN = gsuite_generate_outh_token()
USER_EMAIL = args.username

gsuite_headers = {
    'Authorization': f"Bearer {GSUITE_OAUTH_TOKEN}"
}
my_dict = {}
gsuite_users = gsuite_get_users(gsuite_headers)
if USER_EMAIL in gsuite_users:
    print("User Found")
    print(gsuite_users[USER_EMAIL])
    DISPLAY_NAME = gsuite_users[USER_EMAIL]
    print(DISPLAY_NAME)
    my_dict = {"DISPLAY_NAME" :  DISPLAY_NAME,"USER_EMAIL" : USER_EMAIL} 
    
    with open('userlist.csv', mode='a', newline='') as file:
     writer = csv.DictWriter(file, fieldnames=['DISPLAY_NAME' , 'USER_EMAIL'])
     if file.tell() == 0:
        writer.writeheader()
     writer.writerow(my_dict)
else:
    print("User Not Found")
    exit(1)
