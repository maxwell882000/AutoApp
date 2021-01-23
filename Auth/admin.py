from django.contrib import admin
from django.contrib.admin.views.main import ChangeList
from .models import UserTransport,MarkaRegister,ModelRegister
from .forms import StyleableCheckboxSelectMultiple

admin.site.register(UserTransport)
admin.site.register(ModelRegister)


class MarkaAdmin(admin.ModelAdmin):
    fields = ('name_of_marka', 'model')
    filter_horizontal = ['model']

admin.site.register(MarkaRegister, MarkaAdmin)