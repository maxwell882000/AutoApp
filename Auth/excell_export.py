from import_export import resources
from Auth.models import UserTransport


class UserResource(resources.ModelResource):
    class Meta:
        model = UserTransport
