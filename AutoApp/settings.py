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
CELERY_BROKER_URL = 'redis://127.0.0.1:6379'
CELERY_RESULT_BACKEND = 'redis://127.0.0.1:6379'
CELERY_ACCEPT_CONTENT = ['application/json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'

CELERY_TIMEZONE = "Australia/Tasmania"
CELERY_TASK_TRACK_STARTED = True
CELERY_TASK_TIME_LIMIT = 30 * 60

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

# ALLOWED_HOSTS = ['autoapp.elite-house.uz', 'machina.uz', '127.0.0.1', '185.74.5.208', 'localhost']
ALLOWED_HOSTS = ['192.168.1.2', '0.0.0.0', '185.217.131.41']
PAYME = {
    'url': "https://checkout.paycom.uz/api",
    'headers': {
        'X-Auth': '{id}:{password}'.format(id="60c056c00d44ad63647a92cc",
                                           password="q3VHsvea299Efa4dpDknPfGXx&3Prh&gQhQD")
    },
}
PAYNET = {
    'username': "admin",
    'password': "123123",
    'serviceId': "10",
    'providerId': "00",
    'state': 2
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
    "fcm_django",
    'rest_framework',
    'channels',
    'django_celery_beat',
    "Auth.apps.AuthConfig"
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
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
        'DIRS': [
            os.path.join(BASE_DIR, 'templates')
        ],
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
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'autoapp',
        'USER': 'vid',
        'PASSWORD': '123123_',
        'HOST': 'localhost',
        'PORT': '',
    }
    # 'default': {
    #     'ENGINE': 'django.db.backends.sqlite3',
    #     'NAME': BASE_DIR / 'db.sqlite3',
    # }
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

STATIC_ROOT = os.path.join(BASE_DIR, 'static')
# STATICFILES_DIRS = [
#     os.path.join(BASE_DIR, 'static')
# ]

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
AUTHLIB_OAUTH_CLIENTS = {
    'google': {
        'client_id': "482012990737-8av5d26d4eae2hhoiclird2bkh00t7bk.apps.googleusercontent.com",
        'client_secret': "gp-Wbdjbe1nhIfNdlAOzBM0_",
    },
    'facebook': {
        'client_id': "899459834226658",
        'client_secret': "4ce078f1a3dea24142b92f6bc2d87f5a",
    }
}
CSRF_COOKIE_SECURE = False
CSRF_COOKIE_HTTPONLY = False
ASGI_APPLICATION = "AutoApp.asgi.application"
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
FCM_DJANGO_SETTINGS = {
    # default: _('FCM Django')FCM_DJANGO_SETTINGS
    "APP_VERBOSE_NAME": "Уведомления",
    # Your firebase API KEY
    "FCM_SERVER_KEY": "AAAALD0ZIj0:APA91bEJBjjytIwa3A0Wc1AAs5k9wqxJhJx-CLbUZSZf_oLe-FOzjRKL_2P7oXfnF0295eKbhi5yfQTky83n0NrPuEfcc36A7uvGMR-jT3Z9h7sm58Qu3jew3dxD-mEwYhlukU1hESJU",

    # true if you want to have only one active device per registered user at a time
    # default: False
    "ONE_DEVICE_PER_USER": False,
    # devices to which notifications cannot be sent,
    # are deleted upon receiving error response from FCM
    # default: False
    "DELETE_INACTIVE_DEVICES": False,
    "USER_MODEL": 'Auth.UserTransport'
}
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": [("127.0.0.1", 6379)],
        },
    },
}
