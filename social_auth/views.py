# from django.shortcuts import render, redirect
# from rest_framework import status
# from rest_framework.response import Response
# from rest_framework.generics import GenericAPIView
# from .serializers import GoogleSocialAuthSerializer
# import json
# from django.urls import reverse
# from authlib.integrations.django_client import OAuth

# CONF_URL = 'https://accounts.google.com/.well-known/openid-configuration'
# oauth = OAuth()
# oauth.register(
#     name='google',
#     server_metadata_url=CONF_URL,
#     client_kwargs={
#         'scope': 'openid email profile'
#     }
# )

# def home(request):
#     user = request.session.get('user')
#     if user:
#         user = json.dumps(user)
#     return render(request, 'home.html', context={'user': user})


# def login(request):
#     redirect_uri = request.build_absolute_uri(reverse('auth'))
#     return oauth.google.authorize_redirect(request, redirect_uri)


# def auth(request):
#     token = oauth.google.authorize_access_token(request)
#     user = oauth.google.parse_id_token(request, token)
#     request.session['user'] = user
#     print (user.email)
#     return redirect("http://127.0.0.1:8000/social_auth/google ")

# def logout(request):
#     request.session.pop('user', None)
#     return redirect('/')

# class GoogleSocialAuthView(GenericAPIView):
#     serializer_class = GoogleSocialAuthSerializer
#     def get(self, request):
#         user = request.session.get('user')
#         if user:
#             user = json.dumps(user)
#         return Response({"message":"OKEY"})

#     def post (self, request):
#         print (request)
#         print ("HEREE")
#         serializer = self.serializer_class(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         data = ((serializer.validated_data)['auth_token'])
#         return Response(data, status= status.HTTP_200_OK)

# # Create your views here.
