"""
Django settings for AutoApp project.

Generated by 'django-admin startproject' using Django 3.1.4.

For more information on this file, see
https://docs.djangoproject.com/en/3.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.1/ref/settings/
"""

from pathlib import Path
import os

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

CELERY_BROKER_URL = 'amqp://localhost'
CELERY_TIMEZONE = "Australia/Tasmania"
CELERY_TASK_TRACK_STARTED = True
CELERY_TASK_TIME_LIMIT = 30 * 60
CELERY_RESULT_BACKEND = "rpc://"
# celery setting.
CELERY_CACHE_BACKEND = 'default'
# django setting.
# CELERY_BEAT_SCHEDULE = {
#     "scheduled_task" : {
#         "task" : "Auth.tasks.add",
#         "schedule" : 5.0,
#         "args":   (19,19)
#     }
# }
# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.1/howto/deployment/checklist

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 't-#d-pe&d2v+s_n+vntjm+eu32s$kwg!io%@@zs05kad_b0&x8'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['autoapp.elite-house.uz', '127.0.0.1']

PAYME = {
    'url': "",
    'headers': "",
}
PAYNET = {
    'username': "",
    'password': "",
    'serviceId': "",
    'providerId': "",
}
PAYMENT_HOST = '127.0.0.1:8000'
PAYMENT_USES_SSL = False  # set the True value if you are using the SSL
PAYMENT_MODEL = 'Auth.Payment'
# payment model format like this :: '<app_name>.<model_name>'
# add "click" to your variants
PAYMENT_VARIANTS = {
    'click': ('click.ClickProvider', {
        'merchant_id': 11111,
        'merchant_service_id': 11111,
        'merchant_user_id': 11111,
        'secret_key': 'AAAAAA'
    })
}

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'Auth',
    'rest_framework',
    'django_celery_beat'
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ]
}

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'AutoApp.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'AutoApp.wsgi.application'

# Database
# https://docs.djangoproject.com/en/3.1/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Password validation
# https://docs.djangoproject.com/en/3.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/3.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.1/howto/static-files/

STATIC_URL = '/static/'

MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
MEDIA_URL = '/media/'

AUTHLIB_OAUTH_CLIENTS = {
    'google': {
        'client_id': "219394069897-s12bejr6ha34br64bvq6r4988uot20rv.apps.googleusercontent.com",
        'client_secret': "3QYhiuwg2VWxFc0nah5ZqOp3",
    },
    'facebook': {
        'client_id': "899459834226658",
        'client_secret': "4ce078f1a3dea24142b92f6bc2d87f5a",
    }
}
