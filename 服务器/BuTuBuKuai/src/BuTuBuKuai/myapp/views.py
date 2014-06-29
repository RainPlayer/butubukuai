# -*- coding: utf-8 -*-
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from BuTuBuKuai.myapp.models import Document,UserHeaderImage
from BuTuBuKuai.myapp.forms import DocumentForm,UserHeaderImageForm
from django.views.decorators.csrf import csrf_exempt
import time
from rest_framework import generics 
from HandleDb import HandleNeiHanImageDb,HandleNHImageCommentDB


@csrf_exempt
def list(request):
    # Handle file upload
    if request.method == 'POST':
        form = DocumentForm(request.POST, request.FILES)
        if form.is_valid():
            ntime=time.strftime('%m-%d %H:%M',time.localtime(time.time()))
            newdoc = Document(docfile = request.FILES['docfile'],
                              username=form.cleaned_data['username'],
                              date=ntime,
                              article=form.cleaned_data['article'],
                              praisenumber=3,
                              badnumber=0,
                              imagewidth=form.cleaned_data['imagewidth'],
                              imageheight=form.cleaned_data['imageheight']
                              )
            newdoc.save()  #save to database
            
            # Redirect to the document list after POST
            return HttpResponseRedirect(reverse('BuTuBuKuai.myapp.views.list'))
            
    else:
        form = DocumentForm() # A empty, unbound form

    # Load documents for the list page
    documents = Document.objects.all()
    
    return render_to_response(
        'myapp/upload.html',
        {'documents': documents, 'form': form},
        context_instance=RequestContext(request)
    )
 
 
 
'''
show all neihanimage
'''    
import serializers,models
from rest_framework import viewsets
class DocumentViewSet(viewsets.ModelViewSet):
   
    queryset = models.NeiHanImage.objects.all()
    serializer_class = serializers.NeiHanImageSerializer

'''
修改NHImage赞的数量
'''
class AddNeiHanImagePraiseNumber(generics.ListAPIView):
    serializer_class = serializers.NeiHanImageSerializer

    def get_queryset(self):
        queryset = models.NeiHanImage.objects.all()
        idParam= self.kwargs['id']
        if len(idParam)>0:
            #修改
            HandleNeiHanImageDb.addPraiseNumber(idParam)

        if idParam is not None:
            queryset = queryset.filter(id=idParam)
        return queryset

'''
修改NHImage差评的数量
'''
class AddNeiHanImageBadNumber(generics.ListAPIView):
    serializer_class = serializers.NeiHanImageSerializer

    def get_queryset(self):
        queryset = models.NeiHanImage.objects.all()
        idParam= self.kwargs['id']
        if len(idParam)>0:
            #修改
            HandleNeiHanImageDb.addNaiHanImageBadNumber(idParam)

        if idParam is not None:
            queryset = queryset.filter(id=idParam)
        return queryset



'''
插入评论
'''
class InsertNHImageComment(generics.ListAPIView):
    serializer_class = serializers.NHImageCommentSerializer

    def get_queryset(self):
        queryset = models.NHImageComment.objects.all()
        pid=self.kwargs['pid']
        discussParam=self.kwargs['discuss']
        observerParam=self.kwargs['observer']
        
        HandleNHImageCommentDB.insertNHImageComment(pid, observerParam, discussParam)
       
        if pid is not None:
            queryset = queryset.filter(pid=pid)
        return queryset
    
'''
通过Pmd5code获得所有评论
'''
class GetNHImageCommentByPid(generics.ListAPIView):
    serializer_class = serializers.NHImageCommentSerializer

    def get_queryset(self):
        queryset =models.NHImageComment.objects.all()
       
        pidParam= self.kwargs['pid']
        if pidParam is not None:
            queryset = queryset.filter(pid=pidParam)
        return queryset
  
'''
修改评论赞的数量
'''
class AddNHImageComPraiseNumberById(generics.ListAPIView):
    serializer_class = serializers.NHImageCommentSerializer

    def get_queryset(self):
        queryset = models.NHImageComment.objects.all()
        idParam= self.kwargs['id']
    
        if len(idParam)>0:
            #修改
            HandleNHImageCommentDB.addNHImageComPraiseNumber(idParam)

        if idParam is not None:
            queryset = queryset.filter(id=idParam)
        return queryset 


@csrf_exempt
def userheaderimageupload(request):
    # Handle file upload
   
    if request.method == 'POST':
        
        form = UserHeaderImageForm(request.POST, request.FILES)
        if form.is_valid():
            newdoc = UserHeaderImage(headerimage = request.FILES['headerimage'],
                              id=form.cleaned_data['id']
                              )
            newdoc.save()  #save to database
           
            # Redirect to the document list after POST
            return HttpResponseRedirect(reverse('BuTuBuKuai.myapp.views.userheaderimageupload'))
            
    else:
        form = UserHeaderImageForm() # A empty, unbound form

    # Load documents for the list page
    headerImage = UserHeaderImage.objects.all()
    
    return render_to_response(
        'myapp/list.html',
        {'UserHeaderImage': headerImage, 'form': form},
        context_instance=RequestContext(request)
    )
 



























    
    
