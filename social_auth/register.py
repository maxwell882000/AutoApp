# from django.contrib.auth import authenticate
# from Auth.models import User
# import os
# import random

# from rest_framework.exceptions import AuthenticationFailed

# def register_social_user(provider, user_id, email,name):
#     filtered_user_by_email = User.objects.filter(email = email)

#     if filtered_user_by_email.exists():
#         if provider == filtered_user_by_email[0].auth_provider:
#             registred_user = authenticate(
#                 email = email,
#                 password = os.environ.get('SOCIAL_SECRET')
#             )
#             return {
#                 'email': registred_user.email,
#                 'tokens': registred_user.tokens()
#             }
#         else: 
#             user ={
#                 'email' : email,
#                 'password' : os.environ.get('SOCIAL_SECRET'),
#             }
#             user = User.objects.create_user(**user)
#             user.is_verified = True
#             user.auth_provider = provider
#             user.save()

#             new_user = authenticate(
#                 email = email,
#                 password = os.environ.get('SOCIAL_SECRET')
#             )
#             return {
#                 'email':new_user.email,
#                 'tokens': new_user.tokens()
#             }