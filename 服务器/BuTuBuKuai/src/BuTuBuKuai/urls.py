# -*- coding: UTF-8 -*-  
from django.conf.urls import patterns, url, include
from rest_framework import  routers
from views import UserViewSet,GetUserByName,CreateUserByNameAndPassword,UpdateUserInfoByID,DeleteUserByName,NeiHanArticleViewSet
import views
from django.views.generic import RedirectView
from django.conf import settings
from django.conf.urls.static import static

student_detail = UserViewSet.as_view({
    'get': 'retrieve',
    'put': 'update',
    'patch': 'partial_update',
    'delete': 'destroy'
})

# ViewSets define the view behavior.


# Routers provide an easy way of automatically determining the URL conf
router = routers.DefaultRouter()
router.register(r'user', UserViewSet)
router.register(r'NeiHanArticle', NeiHanArticleViewSet) #
router.register(r'NHArtComment', views.NHArtCommentViewSet)
router.register(r'Poetry', views.PoetryViewSet)
router.register(r'Collection', views.CollectionViewSet)
router.register(r'attention', views.AttentionViewSet)

#router.register(r'Image', views.MyImageViewSet)


'''
    对用户信息的增删改查  create update 需要更新
'''
urlpatterns = patterns('',
    url(r'^', include(router.urls)),
    #通过姓名获得信息 name  .....................................................................
    url('^getUserByName/name=(?P<name>[\w_\u4e00-\u9fa5]{1,100})/$', GetUserByName.as_view()),#get user by name  headerimage
    #创建新的用户 name password
    url('^createUser/name=(?P<name>[\w_\u4e00-\u9fa5]{1,100})&password=(?P<password>\w{1,100})/$',CreateUserByNameAndPassword.as_view()),#create user
    #通过姓名删除用户
    url('^deleteUserByName/name=(?P<name>[\w_\u4e00-\u9fa5]{1,100})/$', DeleteUserByName.as_view()),#delete user by name
    #通过id更改用户信息 name password
    url('^updateUserInfo/id=(?P<id>[0-9]+)&name=(?P<name>[\w_\u4e00-\u9fa5]{1,100})&password=(?P<password>\w{1,100})/$', UpdateUserInfoByID.as_view()),#update userInfo by id
    #关注attention................................
    #通过用户id获得所有关注
    url('^getAttentionsIDs/userid=(?P<userid>[0-9]+)/$',views.GetAttentionsByUserId.as_view()),#获得所关注者ID
    url(r'^getAttentionDetails/userid=(?P<userid>[0-9]+)/$', 'BuTuBuKuai.views.getAttentions'), #获得所关注者的信息
    url(r'^getAttentionCount/userid=(?P<userid>[0-9]+)/$', 'BuTuBuKuai.views.getAttentionCount'),#获得关注个数
    url(r'^addAttention/userid=(?P<userid>[0-9]+)&attentionid=(?P<attentionid>[0-9]+)/$', 'BuTuBuKuai.views.addAttention'),#添加关注
    url(r'^ifAttentioned/userid=(?P<userid>[0-9]+)&attentionid=(?P<attentionid>[0-9]+)/$', 'BuTuBuKuai.views.IfAttentioned'),#判断是否关注
    url(r'^deleteAttention/userid=(?P<userid>[0-9]+)&attentionid=(?P<attentionid>[0-9]+)/$', 'BuTuBuKuai.views.deleteAttention'),#判断是否关注
    
    
    #NeiHanArticle.....................................................................
    #添加内涵段子 userid articel 
    url('^createArticle/userid=(?P<userid>[0-9]+)&article=(?P<article>.+)/$',views.CreateNeiHanArticle.as_view()),#
   #添加内涵段子的好评 md5code
    url('^addNaiHanArticlePraiseNumber/md5code=(?P<md5code>\w{1,50})/$',views.AddNeiHanArticlePraiseNumber.as_view()),
    #添加内涵段子的差评  MD5code
    url('^addNaiHanArticleBadNumber/md5code=(?P<md5code>\w{1,50})/$',views.AddNeiHanArticleBadNumber.as_view()),
    #comment  .....................................................................
    #添加评论 Pmd5code observer discuss
    url('^insertNHArtComment/Pmd5code=(?P<Pmd5code>\w{1,50})&observer=(?P<observer>[\w_\u4e00-\u9fa5]{1,100})&discuss=(?P<discuss>.+)/$',views.InsertNHArtComment.as_view()),
   #通过原文的md5code获得所有评论 
    url('^getNHArtCommentByPmd5code/Pmd5code=(?P<Pmd5code>\w{1,50})/$', views.GetNHArtCommentByPmd5code.as_view()),
   #增加评论的好评
    url('^addNHArtComPraiseNumber/id=(?P<id>[0-9]+)/$',views.AddNHArtComPraiseNumber.as_view()),
    
    #poetry  .....................................................................
    #添加Poetry userid poetry
    url('^createPoetry/userid=(?P<userid>[0-9]+)&poetry=(?P<poetry>.+)/$',views.CreatePoetry.as_view()),#
    #添加Poetry的好评 md5code
    url('^addPoetryPraiseNumber/md5code=(?P<md5code>\w{1,50})/$',views.AddPoetryPraiseNumber.as_view()),
    #添加Poetry的差评  MD5code
    url('^addPoetryBadNumber/md5code=(?P<md5code>\w{1,50})/$',views.AddPoetryBadNumber.as_view()),
    
    # Poetry comment  .....................................................................
    #添加评论 Pmd5code observer discuss
    url('^insertPoetryComment/Pmd5code=(?P<Pmd5code>\w{1,50})&observer=(?P<observer>[\w_\u4e00-\u9fa5]{1,100})&discuss=(?P<discuss>.+)/$',views.InsertPoetryComment.as_view()),
    #通过原文的md5code获得所有评论 
    url('^getPoetryCommentByPmd5code/Pmd5code=(?P<Pmd5code>\w{1,50})/$', views.GetPoetryCommentByPmd5code.as_view()),
    #增加评论的好评
    url('^addPoetryComPraiseNumber/id=(?P<id>[0-9]+)/$',views.AddPoetryComPraiseNumber.as_view()),
    #下载文件   
    url('^fileDownload/filename=(?P<filename>.{1,500})/$', 'BuTuBuKuai.views.file_download'),#download 
    #url('^upload/$', 'BuTuBuKuai.views.addPicture'),  
    #upload file
    #url('^image/$', 'BuTuBuKuai.views.UploadImageForm'),  
    
    url(r'^myapp/', include('BuTuBuKuai.myapp.urls')),
    # collection 收藏
    url(r'^getCollectionNumberByName/collector=(?P<collector>[\w_\u4e00-\u9fa5]{1,100})/$', 'BuTuBuKuai.views.getcollectioncount'),
    url(r'^getCollectionsByName/collector=(?P<collector>[\w_\u4e00-\u9fa5]{1,100})/$', views.GetCollectionsByName.as_view()),
    url(r'^addCollection/collector=(?P<collector>.{1,100})&collectiontype=(?P<collectiontype>\w{1,10})&pid=(?P<pid>\w{1,50})&pmd5code=(?P<pmd5code>\w{0,50})&content=(?P<content>.{1,5000})&imageurl=(?P<imageurl>.{1,500})/$', views.AddCollection.as_view()),
    #通过姓名获得投稿数
    url(r'^getProductionNumber/name=(?P<name>[\w_\u4e00-\u9fa5]{1,100})&id=(?P<id>\w{1,50})/$', 'BuTuBuKuai.views.getProductionByNameAndId'),
    
    url(r'^getPoetrysByUserId/username=(?P<username>[\w_\u4e00-\u9fa5]{1,100})&userid=(?P<userid>\w{1,50})/$', views.GetPoetrysByUserId.as_view()),
    url(r'^getNeiHanArticlesByUserId/username=(?P<username>[\w_\u4e00-\u9fa5]{1,100})&userid=(?P<userid>\w{1,50})/$', views.GetNeiHanArticlesByUserId.as_view()),
    url(r'^getNHImageByUserId/username=(?P<username>[\w_\u4e00-\u9fa5]{1,100})&userid=(?P<userid>\w{1,50})/$', views.GetNHImagesByUserName.as_view()),
    
    
    
    
    
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
)+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)



















