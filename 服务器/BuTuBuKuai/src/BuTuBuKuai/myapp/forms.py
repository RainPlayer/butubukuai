# -*- coding: utf-8 -*-
from django import forms

class DocumentForm(forms.Form):
    docfile = forms.FileField(
        label='选择图片',
        help_text='max. 42 megabytes'
    )
    username=forms.CharField()
    article=forms.CharField()
    imagewidth=forms.FloatField()
    imageheight=forms.FloatField()

#修改用户头像
class UserHeaderImageForm(forms.Form):
    headerimage = forms.FileField(
        label='选择图片',
        help_text='max. 42 megabytes'
    )
    id=forms.IntegerField()