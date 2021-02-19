from django.contrib import admin
from django.contrib.admin.views.main import ChangeList
from .models import UserTransport,MarkaRegister,ModelRegister, SingleRecomendation ,Payment
from .forms import StyleableCheckboxSelectMultiple,CategoryChoiceField

admin.site.register(UserTransport)
admin.site.register(SingleRecomendation)
class PaymentAdmin(admin.ModelAdmin):
    pass

admin.site.register(Payment, PaymentAdmin)
class MarkaAdmin(admin.ModelAdmin):
    fields = ('name_of_marka', 'model')
    filter_horizontal = ['model']

class ModelRecommendationAdmin(admin.ModelAdmin):
    fields = ('name_of_model','recomendations','image_above','text_above')
    filter_horizontal = ['recomendations']

admin.site.register(MarkaRegister, MarkaAdmin)
admin.site.register(ModelRegister,ModelRecommendationAdmin)

# class AbovePartRecomendationAdmin(admin.ModelAdmin):
#     fields = ('marka','model','image','text')
#     my_id_for_formfield = None
#     def get_form(self, request, obj=None, **kwargs):
    
#         if obj:
#             print(obj)
#             self.my_id_for_formfield = obj.model
#         return super(AbovePartRecomendationAdmin, self).get_form(request, obj, **kwargs)

#     def formfield_for_foreignkey(self, db_field, request, **kwargs):
#         self_pub_id = 2
#         if db_field.name == "marka":
#                 #this line below got the proper primary key for our object of interest
#             self_pub_id = request.resolver_match.kwargs.get('object_id', None)
#         if db_field.name == "model":
#             kwargs["queryset"] = MarkaRegister.objects.filter(model = self_pub_id).model
#         return super(AbovePartRecomendationAdmin, self).formfield_for_foreignkey(db_field, request, **kwargs)

    # def formfield_for_foreignkey(self, db_field, request, **kwargs):
    #     if db_field.name == 'marka':
    #         data = MarkaRegister.objects.filter(id = request.selected)
    #         print(data)
    #     if db_field.name == 'model':
    #         return CategoryChoiceField(queryset=ModelRegister.objects.all())
    #     return super().formfield_for_foreignkey(db_field, request, **kwargs)


