'''
Created on 2013-9-19

@author: lele
'''
from django.db import models
 
# Create your models here. 

'''
User
'''

class User(models.Model):
    
    id=models.IntegerField(primary_key=True)
    name= models.CharField(max_length=500)
    password=models.CharField(max_length=100)
    grade=models.CharField(max_length=50)
    headerimage=models.CharField(max_length=500)
    

    class Meta:
        ordering = ('id','name')

'''
'''
class Attention(models.Model):
    
    id=models.IntegerField(primary_key=True)
    userid=models.IntegerField()
    attentionid=models.IntegerField()

    class Meta:
        ordering = ('id','userid')


'''
neihanArticle
'''
class NeiHanArticle(models.Model):
    
    id=models.IntegerField(primary_key=True)
    userid= models.IntegerField()
    date=models.CharField(max_length=45)
    article=models.TextField()
    md5code=models.CharField(max_length=45)
    praisenumber=models.CharField(max_length=10)
    badnumber=models.CharField(max_length=10)

    class Meta:
        ordering = ('id','md5code')        
        
        
        
'''
neihanArticlePingLun
'''
class NHArtComment(models.Model):
    
    id=models.IntegerField(primary_key=True)
    floor= models.IntegerField()
    Pmd5code=models.CharField(max_length=50)
    discuss=models.TextField()
    observer=models.CharField(max_length=50)
    date=models.CharField(max_length=50)
    praisenumber=models.IntegerField()

    class Meta:
        ordering = ('floor','Pmd5code')        
                
'''
shi (Poety)
'''
class Poetry(models.Model):        
    id=models.IntegerField(primary_key=True)
    userid= models.IntegerField()
    date=models.CharField(max_length=45)
    article=models.TextField()
    md5code=models.CharField(max_length=45)
    praisenumber=models.CharField(max_length=10)
    badnumber=models.CharField(max_length=10)

    class Meta:
        ordering = ('id','md5code')
        
'''
PoetryComment
'''
class PoetryComment(models.Model):
    
    id=models.IntegerField(primary_key=True)
    floor= models.IntegerField()
    Pmd5code=models.CharField(max_length=50)
    discuss=models.TextField()
    observer=models.CharField(max_length=50)
    date=models.CharField(max_length=50)
    praisenumber=models.IntegerField()

    class Meta:
        ordering = ('floor','Pmd5code')          

'''

'''
class  Collection(models.Model):
    id=models.IntegerField(primary_key=True)
    collector= models.CharField(max_length=100)
    collectiontype= models.CharField(max_length=45)
    content=models.TextField()
    pmd5code=models.CharField(max_length=100)
    pid=models.IntegerField()
    imageurl=models.CharField(max_length=200)
    class Meta:
        ordering = ('collector','id')   
      
      
      
      
      
      
      
      
        
# '''
# test image upload ............................................................
# '''        
# class MyImage(models.Model):  
#     id=models.IntegerField(primary_key=True)
#     headerimage=models.ImageField(max_length=None)      
#     class Meta:
#         ordering = ('id',)     
from django import forms

class UploadFileForm(forms.Form):
    title = forms.CharField(max_length=50)
    file  = forms.FileField()        
        
        
   
         
        