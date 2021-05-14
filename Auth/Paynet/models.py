from spyne.util.django import DjangoComplexModel
from Auth.models import PaynetProPayment as DjangoPaynetProPayment


class PaynetProPayment(DjangoComplexModel):
    class Attributes(DjangoComplexModel.Attributes):
        django_model = DjangoPaynetProPayment
