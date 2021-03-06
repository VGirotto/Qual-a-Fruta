extends Control

export (NodePath) var botao1Path
export (NodePath) var botao2Path
export (NodePath) var placarPath
export (NodePath) var videoFrutaPath
export (NodePath) var fruta1Path 
export (NodePath) var fruta2Path
export (NodePath) var perguntasFaceisPath
export (NodePath) var timerPath

onready var botao1 = get_node(botao1Path)
onready var botao2 = get_node(botao2Path)
onready var placar = get_node(placarPath)
onready var video = get_node(videoFrutaPath)
onready var fruta1 = get_node(fruta1Path)
onready var fruta2 = get_node(fruta2Path)
onready var perguntasFaceis = get_node(perguntasFaceisPath)
onready var timer = get_node(timerPath)

var score = 0
var acabou = false
var fruta1Text
var fruta2Text
var videoText
var resposta
var penalty = 0

func _ready():
	randomize()
	set_Pergunta()
	
func set_Pergunta():
	var numPerguntas = perguntasFaceis.get_child_count()
	var perguntaAtual
	
	if numPerguntas > 0:
		perguntaAtual = perguntasFaceis.get_child(randi()%numPerguntas)
		fruta1Text = perguntaAtual.fruta1
		fruta2Text = perguntaAtual.fruta2
		videoText = perguntaAtual.video
		fruta1.set_texture(load('res://imagens/'+fruta1Text+'.png'))
		fruta2.set_texture(load('res://imagens/'+fruta2Text+'.png'))
		video.set_stream(load('res://videos/'+videoText+'.ogv'))
		video.play()
		resposta = perguntaAtual.resposta
	else:
		acabou = true
		global.score = score
		get_tree().change_scene('res://cenas/Fim.tscn')
		print("Acabou")
	
	if perguntaAtual != null:
		perguntasFaceis.remove_child(perguntaAtual)
	

func _on_Fruta_1_button_up():
	if fruta1Text == resposta:
		botao1.disabled = true
		botao2.disabled = true
		fruta1.set_texture(load('res://imagens/'+fruta1Text+'Certo.png'))
		score = score + 100 - penalty
		penalty = 0
		print("Você acertou, "+fruta1Text+" "+str(score))
		placar.set_text(" Pontuação : "+str(score))
		timer.start()
	else:
		botao1.disabled = true
		penalty += 10
		print("Você errou, "+fruta1Text+" "+str(score))
		fruta1.set_texture(load('res://imagens/'+fruta1Text+'Errado.png'))
		placar.set_text(" Pontuação : "+str(score))
	

func _on_Fruta_2_button_up():
	if fruta2Text == resposta:
		botao1.disabled = true
		botao2.disabled = true
		fruta2.set_texture(load('res://imagens/'+fruta2Text+'Certo.png'))
		score = score + 100 - penalty
		penalty = 0
		print("Você acertou, "+fruta2Text+" "+str(score))
		placar.set_text(" Pontuação : "+str(score))
		timer.start()
	else:
		botao2.disabled = true
		penalty += 10
		print("Você errou, "+fruta2Text+" "+str(score))
		fruta2.set_texture(load('res://imagens/'+fruta2Text+'Errado.png'))
		placar.set_text(" Pontuação : "+str(score))
	

func _on_timer_timeout():
	set_Pergunta()
	botao1.disabled = false
	botao2.disabled = false

func _on_VideoFruta_finished():
	video.play()
