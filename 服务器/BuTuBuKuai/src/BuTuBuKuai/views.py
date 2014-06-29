# -*- coding: UTF-8 -*-  
'''
Created on 2013-9-19

@author: lele
'''
from django.http import HttpResponse
from models import User,NeiHanArticle,NHArtComment,Poetry
from serializers import UserSerializer,NeiHanArticleSerializer,NHArtCommentSerializer,PoetrySerializer
from rest_framework import viewsets
from rest_framework import generics  
from HandleDb import HandleUserDb,HandleNeiHanArticleDb,HandleNHArtComment,HandlePoetryDb,HandlePoetryComment,HandleCollectionDb,HandleProductionDb,HandleAttentionDb
import models,serializers
from Util import GetMd5Code
from django.views.decorators.csrf import csrf_exempt
from django.utils import simplejson
import json 
'''
获得全部用户列表
'''
class UserViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.

    Additionally we also provide an extra `highlight` action.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    
'''
通过姓名获得用户
'''
class GetUserByName(generics.ListAPIView):
    serializer_class = UserSerializer
    def get_queryset(self):
        queryset = User.objects.all()
        nameParameter= self.kwargs['name']
        if nameParameter is not None:
            queryset = queryset.filter(name=nameParameter)
        return queryset

'''
创建新用户
'''     
class CreateUserByNameAndPassword(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        queryset = User.objects.all()
        nameParam= self.kwargs['name']
        passwordParam=self.kwargs['password']
        result=HandleUserDb.insertUser(nameParam,passwordParam,'菜鸟')

        if result==0 :
            nameParam='&'
        if nameParam is not None:
            queryset = queryset.filter(name=nameParam)
        return queryset
           
    
'''
更改用户信息
'''    

class UpdateUserInfoByID(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        queryset = User.objects.all()
        idParam=self.kwargs['id']
        nameParam= self.kwargs['name']
        passwordParam=self.kwargs['password']
        
        result=HandleUserDb.updateUser(passwordParam, nameParam, idParam)
        #print result #result=1 ok else false
        if nameParam is not None:
            queryset = queryset.filter(id=idParam)
        return queryset
'''
删除用户信息
管理员用
'''
  
class DeleteUserByName(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        queryset = User.objects.all()
        nameParam=self.kwargs['name']
        #print nameParam
        HandleUserDb.deleteUserByName(nameParam);
        if nameParam is not None:
            queryset = queryset.filter(name=nameParam)
        return queryset
    
'''
关注attention.....................................................................
'''  

class AttentionViewSet(viewsets.ModelViewSet):
    queryset = models.Attention.objects.all()
    serializer_class = serializers.AttentionSerializer   
'''
通过用户名获得所有关注者
''' 

@csrf_exempt    
def getAttentions(request, *args, **kwargs):#获得关注者具体信息
    if kwargs.get('userid'):
        userid= kwargs.get('userid')
        
        users=HandleAttentionDb.getAttentionsDetail(userid)#调用数据库函数获得所用关注好友信息
        m = {'attentions': users}
        n = json.dumps(m)  
        lastjson = json.loads(n)  
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False))  
@csrf_exempt    
def getAttentionCount(request, *args, **kwargs):#获得关注者数量
    if kwargs.get('userid'):
        userid= kwargs.get('userid')
        users=HandleAttentionDb.getAttentionCount(userid)#获得关注数量
        m = {'count': users}
        n = json.dumps(m)  
        lastjson = json.loads(n)  
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False)) 
'''
添加关注
'''
@csrf_exempt    
def addAttention(request, *args, **kwargs):#获得关注者数量
    if kwargs.get('userid'):
        userid= kwargs.get('userid')
        attentionid=kwargs.get('attentionid')
        if userid!=attentionid:
            HandleAttentionDb.AddAttention(userid, attentionid)
        lastjson={}
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False)) 
'''
判断是否关注
'''
@csrf_exempt    
def IfAttentioned(request, *args, **kwargs):
    if kwargs.get('userid'):
        userid= kwargs.get('userid')
        attentionid= kwargs.get('attentionid')
        count=HandleAttentionDb.IfAttentioned(userid, attentionid)#关注返回1，未关注返回0
        m = {'count': count}
        n = json.dumps(m)  
        lastjson = json.loads(n)  
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False)) 

'''
取消关注
'''
@csrf_exempt    
def deleteAttention(request, *args, **kwargs):
    if kwargs.get('userid'):
        userid= kwargs.get('userid')
        attentionid= kwargs.get('attentionid')
        HandleAttentionDb.DeleteAttention(userid, attentionid)
        lastjson={}
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False)) 



'''
通过userid获得所有关注者的ID..................................................................
'''  
class GetAttentionsByUserId(generics.ListAPIView):
    serializer_class = serializers.AttentionSerializer
    def get_queryset(self):
        queryset = models.Attention.objects.all()
        useridParam= self.kwargs['userid']
        if useridParam is not None:
            queryset = queryset.filter(userid=useridParam)
        return queryset




    
    
'''
---------------------------------------------------------
内涵段子的函数
''' 



'''
获得全部文章列表
'''
class NeiHanArticleViewSet(viewsets.ModelViewSet):
    queryset = NeiHanArticle.objects.all()
    serializer_class = NeiHanArticleSerializer  
  
'''
发表新话题
'''  
class CreateNeiHanArticle(generics.ListAPIView):
    serializer_class = NeiHanArticleSerializer

    def get_queryset(self):
        queryset = NeiHanArticle.objects.all()
        useridParam= self.kwargs['userid']
        articleParam=self.kwargs['article']
        # get md5code
        if len(articleParam)>0:
            md5codeParam=GetMd5Code.getMd5(articleParam)
            HandleNeiHanArticleDb.insertNeiHanArticle(useridParam, articleParam, md5codeParam)
        

        if articleParam is not None:
            queryset = queryset.filter(md5code=md5codeParam)
        return queryset

'''
'''
'''
通过用户名获得收藏的个数
'''    
import json 
@csrf_exempt    
def getProductionByNameAndId(request, *args, **kwargs):
    if kwargs.get('name'):
        nameParam= kwargs.get('name')
        idParam=kwargs.get('id')
        count=HandleProductionDb.getProductionCount(idParam, nameParam)
        
        m = {'count': count}
        n = json.dumps(m)  
        lastjson = json.loads(n)  
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False))  


'''
通过MD5code删除文章
'''
    
'''
修改赞的数量
'''
class AddNeiHanArticlePraiseNumber(generics.ListAPIView):
    serializer_class = NeiHanArticleSerializer

    def get_queryset(self):
        queryset = NeiHanArticle.objects.all()
        md5codeParam= self.kwargs['md5code']
        if len(md5codeParam)>0:
            #修改
            HandleNeiHanArticleDb.addPraiseNumber(md5codeParam)

        if md5codeParam is not None:
            queryset = queryset.filter(md5code=md5codeParam)
        return queryset

'''
修改贬的数量
'''
class AddNeiHanArticleBadNumber(generics.ListAPIView):
    serializer_class = NeiHanArticleSerializer

    def get_queryset(self):
        queryset = NeiHanArticle.objects.all()
        md5codeParam= self.kwargs['md5code']
        if len(md5codeParam)>0:
            #修改
            HandleNeiHanArticleDb.addNaiHanArticleBadNumber(md5codeParam)

        if md5codeParam is not None:
            queryset = queryset.filter(md5code=md5codeParam)
        return queryset

'''
---------------------------------------------------------
内涵段子评论函数
''' 



'''
获得全部内涵评论
'''
class NHArtCommentViewSet(viewsets.ModelViewSet):
    """
    This viewset automatically provides `list`, `create`, `retrieve`,
    `update` and `destroy` actions.

    Additionally we also provide an extra `highlight` action.
    """
    queryset = NHArtComment.objects.all()
    serializer_class = NHArtCommentSerializer  
  
'''
插入评论
'''
class InsertNHArtComment(generics.ListAPIView):
    serializer_class = NHArtCommentSerializer

    def get_queryset(self):
        queryset = NHArtComment.objects.all()
        Pmd5codeParam=self.kwargs['Pmd5code']
        discussParam=self.kwargs['discuss']
        observerParam=self.kwargs['observer']
        
        HandleNHArtComment.insertNHArtComment(Pmd5codeParam, observerParam, discussParam)
       
        if Pmd5codeParam is not None:
            queryset = queryset.filter(Pmd5code=Pmd5codeParam)
        return queryset
    
'''
通过Pmd5code获得所有评论
'''
class GetNHArtCommentByPmd5code(generics.ListAPIView):
    serializer_class = NHArtCommentSerializer

    def get_queryset(self):
        queryset =NHArtComment.objects.all()
       
        Pmd5codeParam= self.kwargs['Pmd5code']
        if Pmd5codeParam is not None:
            queryset = queryset.filter(Pmd5code=Pmd5codeParam)
        return queryset
  
'''
修改评论赞的数量
'''
class AddNHArtComPraiseNumber(generics.ListAPIView):
    serializer_class = NHArtCommentSerializer

    def get_queryset(self):
        queryset = NHArtComment.objects.all()
        idParam= self.kwargs['id']
    
        if len(idParam)>0:
            #修改
            HandleNHArtComment.addNHArtComPraiseNumber(idParam)

        if idParam is not None:
            queryset = queryset.filter(id=idParam)
        return queryset  
  
'''
.........................................................................
'''  
class PoetryViewSet(viewsets.ModelViewSet):
    queryset = Poetry.objects.all()
    serializer_class = PoetrySerializer  
      
'''
发表新poetry

'''  
class CreatePoetry(generics.ListAPIView):
    serializer_class = PoetrySerializer

    def get_queryset(self):
        queryset = Poetry.objects.all()
        useridParam= self.kwargs['userid']
        poetryParam=self.kwargs['poetry']
        # get md5code
        if len(poetryParam)>0:
            md5codeParam=GetMd5Code.getMd5(poetryParam)
            HandlePoetryDb.insertPoetry(useridParam,poetryParam, md5codeParam)
        

        if poetryParam is not None:
            queryset = queryset.filter(md5code=md5codeParam)
        return queryset
    
'''
修改poetry赞的数量
'''
class AddPoetryPraiseNumber(generics.ListAPIView):
    serializer_class = PoetrySerializer

    def get_queryset(self):
        queryset = Poetry.objects.all()
        md5codeParam= self.kwargs['md5code']
        if len(md5codeParam)>0:
            #修改
            HandlePoetryDb.addPraiseNumber(md5codeParam)

        if md5codeParam is not None:
            queryset = queryset.filter(md5code=md5codeParam)
        return queryset

'''
修改poetry贬的数量
'''
class AddPoetryBadNumber(generics.ListAPIView):
    serializer_class = PoetrySerializer

    def get_queryset(self):
        queryset = Poetry.objects.all()
        md5codeParam= self.kwargs['md5code']
        
        if len(md5codeParam)>0:
            #修改
            HandlePoetryDb.addPoetryBadNumber(md5codeParam)

        if md5codeParam is not None:
            queryset = queryset.filter(md5code=md5codeParam)
        return queryset
    


'''
---------------------------------------------------------
Poetry评论函数
''' 



'''
获得全部内涵评论
'''
class PoetryCommentViewSet(viewsets.ModelViewSet):
    queryset = models.PoetryComment.objects.all()
    serializer_class = serializers.PoetryCommentSerializer  
  
'''
插入评论
'''
class InsertPoetryComment(generics.ListAPIView):
    serializer_class = serializers.PoetryCommentSerializer

    def get_queryset(self):
        queryset = models.PoetryComment.objects.all()
        Pmd5codeParam=self.kwargs['Pmd5code']
        discussParam=self.kwargs['discuss']
        observerParam=self.kwargs['observer']
        #print (Pmd5codeParam,discussParam,observerParam)
        HandlePoetryComment.insertPoetryComment(Pmd5codeParam, observerParam, discussParam)
       
        if Pmd5codeParam is not None:
            queryset = queryset.filter(Pmd5code=Pmd5codeParam)
        return queryset
    
'''
通过Pmd5code获得所有评论
'''
class GetPoetryCommentByPmd5code(generics.ListAPIView):
    serializer_class = serializers.PoetryCommentSerializer

    def get_queryset(self):
        queryset =models.PoetryComment.objects.all()
       
        Pmd5codeParam= self.kwargs['Pmd5code']
        if Pmd5codeParam is not None:
            queryset = queryset.filter(Pmd5code=Pmd5codeParam)
        return queryset
  
'''
修改评论赞的数量
'''
class AddPoetryComPraiseNumber(generics.ListAPIView):
    serializer_class = serializers.PoetryCommentSerializer

    def get_queryset(self):
        queryset = models.PoetryComment.objects.all()
        idParam= self.kwargs['id']
    
        if len(idParam)>0:
            #修改
            HandlePoetryComment.addPoetryComPraiseNumber(idParam)

        if idParam is not None:
            queryset = queryset.filter(id=idParam)
        return queryset      
'''
下载文件
'''    
    
from django.core.servers.basehttp import FileWrapper  
#import mimetypes  
import settings  
import os 
    
def file_download(request, filename):  
  
    filepath = os.path.join(settings.MEDIA_ROOT, filename)      
    wrapper = FileWrapper(open(filepath, 'rb'))  
    #content_type = mimetypes.guess_type(filepath)[0]  
    response = HttpResponse(wrapper, mimetype='content_type')  
    response['Content-Disposition'] = "attachment; filename=%s" % filename  
    return response    
'''
about collection
'''    
'''
获得全部用户列表
'''
class CollectionViewSet(viewsets.ModelViewSet):
    queryset = models.Collection.objects.all()
    serializer_class = serializers.CollectionSerializer
    
    
'''
通过用户名获得收藏的个数
'''    
@csrf_exempt    
def getcollectioncount(request, *args, **kwargs):
    if kwargs.get('collector'):
        # Do something here ..
        collector= kwargs.get('collector')
        
        count=HandleCollectionDb.getCollectionCount(collector)
        m = {'count': count}
        n = json.dumps(m)  
        lastjson = json.loads(n)  
        return HttpResponse(simplejson.dumps(lastjson,ensure_ascii = False))  

    
'''
通过姓名获得全部收藏
'''
class GetCollectionsByName(generics.ListAPIView):
    serializer_class = serializers.CollectionSerializer
    def get_queryset(self):
        queryset = models.Collection.objects.all()
       
        collectorParameter= self.kwargs['collector']
        if collectorParameter is not None:
            queryset = queryset.filter(collector=collectorParameter)
        return queryset          
    
'''
添加收藏
'''
class AddCollection(generics.ListAPIView):
    serializer_class = serializers.CollectionSerializer
    def get_queryset(self):
        queryset = models.Collection.objects.all()
       
        collectorParameter= self.kwargs['collector']
        collectiontypeParameter= self.kwargs['collectiontype']
        pidParameter= self.kwargs['pid']
        pmd5codeParameter= self.kwargs['pmd5code']
        contentParameter= self.kwargs['content']
        imageurlParameter= self.kwargs['imageurl']
        
        #print collectorParameter,collectiontypeParameter,pidParameter,pmd5codeParameter,contentParameter,imageurlParameter
        HandleCollectionDb.addCollection(collectorParameter, collectiontypeParameter, pidParameter, pmd5codeParameter, contentParameter, imageurlParameter)
        if collectorParameter is not None:
            queryset = queryset.filter(collector='')
        return queryset          
        


'''
通过用户名获得投稿
'''

class GetNeiHanArticlesByUserId(generics.ListAPIView):
    serializer_class = NeiHanArticleSerializer

    def get_queryset(self):
        queryset = NeiHanArticle.objects.all()
        useridParam= self.kwargs['userid']
        usernameParam=self.kwargs['username']
        
        if useridParam is not None:
            queryset = queryset.filter(userid=useridParam)
        return queryset
    
    
class GetPoetrysByUserId(generics.ListAPIView):
    serializer_class = PoetrySerializer

    def get_queryset(self):
        queryset = Poetry.objects.all()
        useridParam= self.kwargs['userid']
        usernameParam=self.kwargs['username']
        
        if useridParam is not None:
            queryset = queryset.filter(userid=useridParam)
        return queryset

from myapp.models import NeiHanImage  
from myapp.serializers import NeiHanImageSerializer  
class GetNHImagesByUserName(generics.ListAPIView):
    serializer_class = NeiHanImageSerializer

    def get_queryset(self):
        queryset = NeiHanImage.objects.all()
        useridParam= self.kwargs['userid']
        usernameParam=self.kwargs['username']
        
        if useridParam is not None:
            queryset = queryset.filter(username=usernameParam)
        return queryset













    
    
    
    