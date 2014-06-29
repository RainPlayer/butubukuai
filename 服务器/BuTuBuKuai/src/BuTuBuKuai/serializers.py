# -*- coding: UTF-8 -*-  
'''
Created on 2013-9-19

@author: lele
'''
#from django.forms import widgets
from rest_framework import serializers
from models import User,NeiHanArticle,NHArtComment,Poetry,Attention
import models



class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'name','password','grade','headerimage')
    id = serializers.IntegerField()  # Note: `Field` is an untyped read-only field.
    name= serializers.CharField(max_length=100)
    password=serializers.CharField(max_length=100)
    grade=serializers.CharField(max_length=50)
    score=serializers.IntegerField() 
    headerimage=serializers.CharField(max_length=500)
    
        
    def restore_object(self, attrs, instance=None):
        """
        Create or update a new snippet instance.
        """
        if instance:
            # Update existing instance
            instance.Panme = attrs['name']
            instance.id = attrs['id']
            instance.password=attrs['password']
            instance.grade=attrs['grade']
            instance.headerimage=attrs['headerimage']
            
            return instance

        # Create new instance
        return User(**attrs)
'''
关注attention
'''    
class AttentionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Attention
        fields = ('id', 'userid','attentionid')
    id = serializers.IntegerField()  
    userid = serializers.IntegerField()  
    attentionid = serializers.IntegerField()  
    def restore_object(self, attrs, instance=None):
        if instance:
            instance.id = attrs['id']
            instance.userid = attrs['userid']
            instance.attentionid = attrs['attentionid']
            return instance
        return Attention(**attrs)    

    
class NeiHanArticleSerializer(serializers.ModelSerializer):
    class Meta:
        model = NeiHanArticle
        fields = ('id', 'userid','date','article','md5code','praisenumber','badnumber')
    id = serializers.IntegerField() 
    userid= serializers.IntegerField()
    date=serializers.CharField(max_length=100)
    article=serializers.CharField()
    md5code=serializers.CharField(max_length=45)
    praisenumber=serializers.IntegerField() 
    badnumber=serializers.IntegerField()
    
        
    def restore_object(self, attrs, instance=None):
        """
        Create or update a new snippet instance.
        """
        if instance:
            # Update existing instance
            instance.id = attrs['id']
            instance.userid = attrs['userid']
            instance.date=attrs['date']
            instance.article=attrs['article']
            instance.md5code=attrs['md5code']
            instance.praisenumber=attrs['praisenumber']
            instance.badnumber=attrs['badnumber']
            
            
            
            return instance

        # Create new instance
        return User(**attrs)
        
'''
neihanarticle comment
'''    
class NHArtCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = NHArtComment
        fields = ('floor', 'Pmd5code','discuss','observer','date','praisenumber','id')
    id = serializers.IntegerField() 
    floor= serializers.IntegerField()
    Pmd5code=serializers.CharField()
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
            instance.Pmd5code=attrs['Pmd5code']
            instance.discuss=attrs['discuss']
            instance.observer=attrs['observer']
            instance.date=attrs['date']
            instance.praisenumber=attrs['praisenumber']
            
            
            
            return instance

        # Create new instance
        return User(**attrs)
    
'''
poetry 
'''    
class PoetrySerializer(serializers.ModelSerializer):
    class Meta:
        model = Poetry
        fields = ('id', 'userid','date','article','md5code','praisenumber','badnumber')
    id = serializers.IntegerField() 
    userid= serializers.IntegerField()
    date=serializers.CharField(max_length=100)
    article=serializers.CharField()
    md5code=serializers.CharField(max_length=45)
    praisenumber=serializers.IntegerField() 
    badnumber=serializers.IntegerField()
    
        
    def restore_object(self, attrs, instance=None):
        """
        Create or update a new snippet instance.
        """
        if instance:
            # Update existing instance
            instance.id = attrs['id']
            instance.userid = attrs['userid']
            instance.date=attrs['date']
            instance.article=attrs['article']
            instance.md5code=attrs['md5code']
            instance.praisenumber=attrs['praisenumber']
            instance.badnumber=attrs['badnumber']
            
            
            
            return instance

        # Create new instance
        return Poetry(**attrs)    
'''
poetry comment
'''    
class PoetryCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.PoetryComment
        fields = ('floor', 'Pmd5code','discuss','observer','date','praisenumber','id')
    id = serializers.IntegerField() 
    floor= serializers.IntegerField()
    Pmd5code=serializers.CharField()
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
            instance.Pmd5code=attrs['Pmd5code']
            instance.discuss=attrs['discuss']
            instance.observer=attrs['observer']
            instance.date=attrs['date']
            instance.praisenumber=attrs['praisenumber']
            
            
            
            return instance

        # Create new instance
        return models.PoetryComment(**attrs)
'''
collection
'''
class CollectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Collection
        fields = ('id', 'collector','collectiontype','content','pmd5code','pid','imageurl')
    id = serializers.IntegerField()  # Note: `Field` is an untyped read-only field.
    collector= serializers.CharField(max_length=100)
    collectiontype=serializers.CharField(max_length=45)
    content=serializers.CharField()
    pmd5code=serializers.CharField(max_length=100)
    pid=serializers.IntegerField()
    imageurl=serializers.CharField()
        
    def restore_object(self, attrs, instance=None):
        """
        Create or update a new snippet instance.
        """
        if instance:
            # Update existing instance
            instance.id = attrs['id']
            instance.collector=attrs['collector']
            instance.collectiontype=attrs['collectiontype']
            instance.content=attrs['content']
            instance.pmd5code=attrs['pmd5code']
            instance.pid=attrs['pid']
            instance.imageurl=attrs['imageurl']
            
            return instance

        # Create new instance
        return models.Collection(**attrs)
    
    
    
    
    
    
    
    
    
    
            
    
    