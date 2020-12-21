# from rest_framework import serializers
# from . import google 
# from .register import register_social_user
# import os
# from rest_framework.exceptions import AuthenticationFailed

# class GoogleSocialAuthSerializer(serializers.Serializer):
#     auth_token = serializers.CharField()

#     def validate_auth_token(self,auth_token):
#         GOOGLE_CLIENT_ID = "219394069897-s12bejr6ha34br64bvq6r4988uot20rv.apps.googleusercontent.com"
#         user_data = google.Google.validate(auth_token)
#         try:
#             user_data['sub']
#         except:
#             raise serializers.ValidationError(
#             'The token is invalid or expired.Please login again'
#         )
#         if user_data['aud']  != GOOGLE_CLIENT_ID:
#             raise AuthenticationFailed('oops, who are you?')
#         user_id = user_data['sub']
#         email = user_data['email']
#         provider = 'google'

#         return register_social_user(
#             provider=provider,
#             user_id= user_id,
#             email = email,
#         )