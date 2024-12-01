extends AudioStreamPlayer

const main_menu_music = preload("res://main_menu/GunSlinger Menu.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music_main_menu():
	_play_music(main_menu_music)
