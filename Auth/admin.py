from django.contrib import admin
from django.contrib.admin import AdminSite
from fcm_django.models import FCMDevice
from .models import UserTransport, MarkaRegister, ModelRegister, \
    SingleRecomendation, Adds, AmountProAccount, \
    Message, RecommendCards, PaynetProPayment

from django.contrib.auth.models import Group, User
from django.db.models import Q, F, ExpressionWrapper, FloatField, Case, Value, When
from django.db.models.functions import (
    ExtractDay, ExtractMonth, ExtractYear, Now)
from import_export.admin import ImportExportModelAdmin
from Auth.excell_export import UserResource

AdminSite.site_title = "Админка"
AdminSite.site_header = "Auto App"
AdminSite.index_title = "Админка"
admin.site.unregister(Group)
admin.site.unregister(User)
admin.site.register(Adds)
admin.site.register(UserTransport)


class UserAdmin(ImportExportModelAdmin):
    resource_class = UserResource


admin.site.register(UserTransport, UserAdmin)
admin.site.register(AmountProAccount)

#
# class SingleRecomendationAdmin(admin.ModelAdmin):
#     def get_model_perms(self, request):
#         """
#         Return empty perms dict thus hiding the model from admin index.
#         """
#         return {}


admin.site.register(SingleRecomendation)

admin.site.register(RecommendCards)


class MessagesAdmin(admin.ModelAdmin):
    actions = ("send_message_to_all",)
    filter_horizontal = ['type_cards']

    def send_message_to_all(self, request, queryset):

        for message in queryset:
            devices = self.calculate_procent(FCMDevice.objects.select_related('user')).filter(
                Q(procent__gte=80) & self.get_cards(card=message.type_cards))
            # FCMDevice.objects.filter(user_id__gt=)
            for device in devices:
                response = device.send_data_message(data_message={
                    'title': message.title,
                    'body': message.body
                })
                self.message_user(request, response)

    send_message_to_all.short_description = "Отправить всем пользователям"

    def get_run(self, type: int):
        if type == 0:
            return Q()
        elif type == 1:
            return Q(user__cards__run__lte=100000)
        elif type == 2:
            return Q(user__cards__run__gt=100000) & Q(user__cards__run__lte=200000)
        elif type == 3:
            return Q(user__cards__run__gt=200000)

    def get_cards(self, card):
        return Q(user__cards__cards_user__card__in=card)

    def calculate_procent(self, obj):
        run_current = "user__cards__run"
        expression = "user__cards__cards_user__card"
        date = expression + "__date"
        run = Q(user__cards__cards_user__card__change__run=0)
        time_remained = expression + "__change__time"
        run_remained = expression + "__change__run"
        run_initial = expression + "__change__initial_run"
        return obj.annotate(now_days=ExtractDay(Now()),
                            now_month=ExtractMonth(Now()),
                            now_year=ExtractYear(Now()),
                            days=ExtractDay(date),
                            month=ExtractMonth(date),
                            year=ExtractYear(date),
                            ).annotate(
            passed_days=ExpressionWrapper(F('now_days') - F('days') + 31 * (F('now_month') - F('month')) + 365 * (
                    F('now_year') - F('year')), output_field=FloatField()),
            run_total=F(run_remained) - F(run_initial),
            run_passed=F(run_current) - F(run_initial),
        ).annotate(
            procent=Case(
                When(Q(passed_days__gt=0) & run, then=ExpressionWrapper(F(time_remained) / F('passed_days') * 100,
                                                                        output_field=FloatField())),
                When(~Q(run_passed__lte=0), then=ExpressionWrapper(F('run_total') / F('run_passed') * 100,
                                                                   output_field=FloatField())),
                default=0.0,
            ),
        )

    def calculate_average(self, obj):
        return obj.annotate(now_days=ExtractDay(Now()),
                            now_month=ExtractMonth(Now()),
                            now_year=ExtractYear(Now()),
                            days=ExtractDay('user__date'),
                            month=ExtractMonth('user__date'),
                            year=ExtractYear('user__date'),
                            ).annotate(
            calculate_days=F('now_days') - F('days') + 31 * (F('now_month') - F('month')) + 365 * (
                    F('now_year') - F('year')),
            run_passed=ExpressionWrapper(F('user__cards__run') - F('user__cards__initial_run'),
                                         output_field=FloatField())
        ).annotate(average_speed=ExpressionWrapper(F('run_passed') / F('calculate_days'),
                                                   output_field=FloatField()))


admin.site.register(Message, MessagesAdmin)


class PaynetProPaymentAdmin(admin.ModelAdmin):
    fields = ('user',)


admin.site.register(PaynetProPayment, PaynetProPaymentAdmin)


# class PaymentAdmin(admin.ModelAdmin):
#     pass

# admin.site.register(Payment, PaymentAdmin)
class MarkaAdmin(admin.ModelAdmin):
    fields = ('name_of_marka', 'model')
    filter_horizontal = ['model']


class ModelRecommendationAdmin(admin.ModelAdmin):
    fields = ('name_of_model', 'recomendations', 'recommend_card', 'image_above', 'text_above')
    filter_horizontal = ['recomendations', 'recommend_card']

    # def get_model_perms(self, request):
    #     """
    #     Return empty perms dict thus hiding the model from admin index.
    #     """
    #     return {}


admin.site.register(MarkaRegister, MarkaAdmin)
admin.site.register(ModelRegister, ModelRecommendationAdmin)

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
