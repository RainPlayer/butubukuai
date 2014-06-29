from django.db import models

class Document(models.Model):
    id=models.IntegerField(primary_key=True)
    docfile = models.FileField(upload_to='documents/%Y/%m/%d')
    username=models.CharField(max_length=100)
    date=models.CharField(max_length=45)
    article=models.TextField()
    praisenumber=models.IntegerField()
    badnumber=models.IntegerField()
    imagewidth=models.FloatField()
    imageheight=models.FloatField()
    
    class Meta:
        
        ordering = ('id','username')
        
        
        
        
        
class NeiHanImage(models.Model):
    id=models.IntegerField(primary_key=True)
    docfile = models.CharField(max_length=500)
    username=models.CharField(max_length=100)
    date=models.CharField(max_length=45)
    article=models.TextField()
    praisenumber=models.IntegerField()
    badnumber=models.IntegerField()
    imagewidth=models.FloatField()
    imageheight=models.FloatField()
    class Meta:
        db_table = 'myapp_document'
        ordering = ('id',)    
        
        
        
        
'''
NHImageComment
'''
class NHImageComment(models.Model):
    
    id=models.IntegerField(primary_key=True)
    floor= models.IntegerField()
    pid=models.IntegerField()
    discuss=models.TextField()
    observer=models.CharField(max_length=50)
    date=models.CharField(max_length=50)
    praisenumber=models.IntegerField()

    class Meta:
        ordering = ('floor','pid')   
        
class UserHeaderImage(models.Model):
    id=models.IntegerField(primary_key=True)
    headerimage = models.FileField(upload_to='headerimage')
    class Meta:
        db_table = 'butubukuai_user'
        ordering = ('id','headerimage')        
        
        
        
        
        