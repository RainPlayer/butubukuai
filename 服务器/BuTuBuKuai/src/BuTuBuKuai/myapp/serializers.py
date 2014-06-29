'''
Created on 2013-9-19

@author: lele
'''
#from django.forms import widgets
from rest_framework import serializers

import models
class NeiHanImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.NeiHanImage
        fields = ('id', 'docfile','username', 'date','article', 'praisenumber','badnumber','imagewidth','imageheight')
    id = serializers.IntegerField()  
    docfile= serializers.CharField(max_length=100)
    username=serializers.CharField(max_length=100)
    
    date=serializers.CharField(max_length=45)
    article=serializers.CharField(max_length=1000)
    praisenumber=serializers.IntegerField()
    badnumber=serializers.IntegerField()
    imagewidth=serializers.FloatField()
    imageheight=serializers.FloatField()
    
        
    def restore_object(self, attrs, instance=None):
        """
        Create or update a new snippet instance.
        """
        if instance:
            # Update existing instance
            instance.id = attrs['id']
            instance.docfile = attrs['docfile']
            instance.username=attrs['username']
            
            instance.date = attrs['date']
            instance.article=attrs['article']
            instance.praisenumber = attrs['praisenumber']
            instance.badnumber=attrs['badnumber']
            instance.imagewidth=attrs['width']
            instance.imageheight=attrs['height']
            return instance

        # Create new instance
        return models.NeiHanImage(**attrs)
    

'''
neihanImagecomment
'''    
class NHImageCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.NHImageComment
        fields = ('floor', 'pid','discuss','observer','date','praisenumber','id')
    id = serializers.IntegerField() 
    floor= serializers.IntegerField()
    pid=serializers.IntegerField()
    discuss=serializers.CharField()
    observer=serializers.CharField()
    date=serializers.CharField()
    praisenumber=serializers.IntegerField()
    def restore_object(self, attrs, instance=None):
        """
        Create or update a new snippet instance.
        """
        if instance:
            # Update existing instance
            instance.id = attrs['id']
            instance.floor = attrs['floor']
            instance.pid=attrs['pid']
            instance.discuss=attrs['discuss']
            instance.observer=attrs['observer']
            instance.date=attrs['date']
            instance.praisenumber=attrs['praisenumber']
            return instance
        # Create new instance
        return models.NHImageComment(**attrs)    
    
    
    
    
    
    
    
            
    
    