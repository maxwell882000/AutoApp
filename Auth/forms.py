from django import forms
from django.forms.utils import flatatt
from django.utils.safestring import mark_safe


class StyleableCheckboxSelectMultiple(forms.CheckboxSelectMultiple):
    def __init__(self, attrs=None, ul_attrs=None):
        self.ul_attrs = ul_attrs
        super().__init__(attrs)

    def render(self, name, value, attrs=None, choices=None):
        html = super().render(name, value, attrs, choices)
        final_attrs = self.build_attrs(self.ul_attrs)
        return mark_safe(html.replace('<ul', f'<ul {flatatt(final_attrs)}'))