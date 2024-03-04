---- Turkish language strings

local L = LANG.CreateLanguage("Turkish")

-- General text used in various places
L.traitor    = "Hain"
L.detective  = "Dedektif"
L.innocent   = "Masum"
L.last_words = "Son Sözleri"

L.terrorists = "Teröristler"
L.spectators = "İzleyiciler"

-- Round status messages
L.round_minplayers = "Yeni bir raunda başlamak için yeterli oyuncu yok..."
L.round_voting     = "Oylama devam ediyor, yeni raunt {num} saniye geciktiriliyor..."
L.round_begintime  = "Yeni bir raunt {num} saniye içinde başlıyor. Kendini hazırla."
L.round_selected   = "Hainler seçildi."
L.round_started    = "Raunt başladı!"
L.round_restart = "Raunt bir yönetici tarafından yeniden başlatıldı."

L.round_traitors_one = "Hey hain, yalnızsın."
L.round_traitors_more = "Hey hain, bunlar senin müttefiklerin {names}"

L.win_time = "Süre doldu. Hainler kaybetti."
L.win_traitor      = "Hainler kazandı!"
L.win_innocent     = "Hainler yenildi!"
L.win_showreport = "{num} saniye boyunca raunt raporuna bakalım."

L.limit_round      = "Raunt limitine ulaşıldı. {mapname} yakında yüklenecek."
L.limit_time       = "Süre sınırına ulaşıldı. {mapname} yakında yüklenecek."
L.limit_left = "Harita değişmeden önce {num} raunt veya {time} dakika kaldı."

-- Credit awards
L.credit_det_all   = "Dedektifler, performansınız için size {num} ekipman kredisi verildi."
L.credit_tr_all    = "Hainler, performansınız için size {num} ekipman kredisi verildi."

L.credit_kill = "Bir {role} öldürdüğünüz için {num} kredi aldınız."

-- Karma
L.karma_dmg_full = "Karman {amount}, bu yüzden bu raunt tam hasar veriyorsun!"
L.karma_dmg_other = "Karman {amount}. bu yüzden verdiğin hasar %{num} azaltılacak"

-- Body identification messages
L.body_found = "{finder}, {victim} adlı kişinin cesedini buldu. {role}"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_t     = "Onlar bir Haindi!"
L.body_found_d = "Onlar bir Dedektifti."
L.body_found_i     = "Onlar bir Masumdu."

L.body_confirm = "{finder}, {victim} adlı kişinin ölümünü doğruladı."

L.body_call = "{player}, {victim} adlı kurbanın cesedine Dedektif çağırdı!"
L.body_call_error = "Bir Dedektif çağırmadan önce bu oyuncunun ölümünü onaylamalısın!"

L.body_burning = "Ah! Bu ceset yanıyor!"
L.body_credits = "Cesette {num} kredi buldunuz!"

-- Menus and windows
L.close = "Kapat"
L.cancel = "İptal"

-- For navigation buttons
L.next = "Sonraki"
L.prev = "Önceki"

-- Equipment buying menu
L.equip_title = "Ekipman"
L.equip_tabtitle = "Ekipman Sipariş Et"

L.equip_status = "Sipariş durumu"
L.equip_cost = "{num} krediniz kaldı."
L.equip_help_cost = "Satın aldığınız her ekipman parçası 1 krediye mal olur."

L.equip_help_carry = "Yalnızca yeriniz olduğunda bir şeyler satın alabilirsiniz."
L.equip_carry = "Bu ekipmanı taşıyabilirsiniz."
L.equip_carry_own = "Bu öğeyi zaten taşıyorsunuz."
L.equip_carry_slot = "{slot} yuvasında zaten bir silah taşıyorsun."

L.equip_help_stock = "Belirli öğelerden her rauntta yalnızca bir tane satın alabilirsiniz."
L.equip_stock_deny = "Bu ürün artık stokta yok."
L.equip_stock_ok = "Bu ürün stokta mevcut."

L.equip_custom = "Bu sunucu tarafından eklenen özel öğedir."

L.equip_spec_name = "Ad"
L.equip_spec_type = "Tür"
L.equip_spec_desc = "Açıklama"

L.equip_confirm = "Ekipman satın al"

-- Disguiser tab in equipment menu
L.disg_name = "Kılık Değiştirici"
L.disg_menutitle = "Kılık değiştirme kontrolü"
L.disg_not_owned = "Kılık Değiştirici taşımıyorsun!"
L.disg_enable = "Kılık değiştirmeyi etkinleştir"

L.disg_help1 = "Kılık değiştiğinde, biri sana baktığında adın, sağlığın ve Karman gösterilmez. Ayrıca, bir Dedektifin radarından gizleneceksiniz."
L.disg_help2 = "Menüyü kullanmadan kılık değiştirmek için Numpad Enter tuşuna basın. Konsolu kullanarak farklı bir tuşa 'ttt_toggle_digguise' olarak da atayabilirsiniz."

-- Radar tab in equipment menu
L.radar_name = "Radar"
L.radar_menutitle = "Radar kontrolü"
L.radar_not_owned = "Radar taşımıyorsun!"
L.radar_scan = "Tarama yap"
L.radar_auto = "Otomatik tekrarlı tarama"
L.radar_help = "Tarama sonuçları {num} saniye boyunca gösterilir, bundan sonra Radar yeniden yüklenir ve tekrar kullanılabilir."
L.radar_charging = "Radarın hala şarj oluyor!"

-- Transfer tab in equipment menu
L.xfer_name = "Transfer"
L.xfer_menutitle = "Kredi transferi"
L.xfer_no_credits = "Verecek krediniz yok!"
L.xfer_send = "Kredi gönder"
L.xfer_help       = "Kredileri yalnızca diğer {role} oyuncularına aktarabilirsin."

L.xfer_no_recip = "Alıcı geçerli değil, kredi transferi iptal edildi."
L.xfer_no_credits = "Transfer için yetersiz kredi."
L.xfer_success = "{player} adlı oyuncuya kredi transferi tamamlandı."
L.xfer_received = "{player} sana {num} kredi verdi."

-- Radio tab in equipment menu
L.radio_name = "Radyo"
L.radio_help = "Radyonuzun bu sesi çalmasını sağlamak için bir düğmeye tıklayın."
L.radio_notplaced = "Sesi çalmak için Radyoyu yerleştirmelisiniz."

-- Radio soundboard buttons
L.radio_button_scream = "Çığlık sesi"
L.radio_button_expl = "Patlama sesi"
L.radio_button_pistol = "Tabanca atışları"
L.radio_button_m16 = "M16 atışları"
L.radio_button_deagle = "Deagle atışları"
L.radio_button_mac10 = "MAC10 atışları"
L.radio_button_shotgun = "Pompalı tüfek atışları"
L.radio_button_rifle = "Tüfek atışı"
L.radio_button_huge = "H.U.G.E. patlaması"
L.radio_button_c4 = "C4 bip sesi"
L.radio_button_burn = "Yanma sesi"
L.radio_button_steps = "Adım sesi"


-- Intro screen shown after joining
L.intro_help = "Oyunda yeniyseniz, talimatlar için F1'e basın!"

-- Radiocommands/quickchat
L.quick_title = "Hızlı sohbet tuşları"

L.quick_yes = "Evet."
L.quick_no = "Hayır."
L.quick_help = "Yardım edin!"
L.quick_imwith = "{player} ile birlikteyim."
L.quick_see = "{player} adlı oyuncuyu görüyorum."
L.quick_suspect = "{player} şüpheli davranıyor."
L.quick_traitor = "{player} bir Hain!"
L.quick_inno = "{player} masum."
L.quick_check = "Kimse hayatta mı?"

-- {player} in the quickchat text normally becomes a player nickname, but can
-- also be one of the below.  Keep these lowercase.
L.quick_nobody = "hiç kimse"
L.quick_disg = "kılık değiştirmiş biri var"
L.quick_corpse = "kimliği belirsiz bir ceset var"
L.quick_corpse_id = "{player} oyuncusunun cesedi"


-- Body search window
L.search_title = "Ceset Arama Sonuçları"
L.search_info = "Bilgi"
L.search_confirm = "Ölümü Onayla"
L.search_call = "Dedektif Çağır"

-- Descriptions of pieces of information found
L.search_nick = "Bu, {player} oyuncusunun cesedi."

L.search_role_t = "Bu kişi bir Haindi!"
L.search_role_d = "Bu kişi bir Dedektifti."
L.search_role_i = "Bu kişi masum bir teröristti."

L.search_words = "İçinizden bir ses bu kişinin son sözlerinden bazılarının '{lastwords}' olduğunu söylüyor."
L.search_armor = "Standart olmayan vücut zırhı giyiyorlardı."
L.search_disg = "Kimliklerini gizleyebilecek bir cihaz taşıyorlardı."
L.search_radar = "Bir çeşit radar taşıyorlardı. Artık çalışmıyor."
L.search_c4 = "Cebinde bir not buldun. {num} numaralı teli kesmenin bombayı güvenli bir şekilde etkisiz hale getireceğini belirtiyor."

L.search_dmg_crush = "Kemiklerinin çoğu kırılmış. Ağır bir nesnenin çarpması onları öldürmüş gibi görünüyor."
L.search_dmg_bullet = "Vurularak öldürüldükleri belli."
L.search_dmg_fall = "Düşüp öldüler."
L.search_dmg_boom = "Yaraları ve yanmış kıyafetleri bir patlamanın sonlarına neden olduğunu gösteriyor."
L.search_dmg_club = "Ceset çürümüş ve hırpalanmış. Belli ki dövülerek öldürülmüşler."
L.search_dmg_drown = "Ceset boğulma belirtileri gösteriyor."
L.search_dmg_stab = "Kanamadan hızlı bir şekilde ölmeden önce bıçaklandılar ve kesildiler."
L.search_dmg_burn = "Buralar kızartılmış terörist gibi kokuyor..."
L.search_dmg_tele = "DNA'ları takyon emisyonları tarafından karıştırılmış gibi görünüyor!"
L.search_dmg_car = "Bu terörist yolu geçtiğinde, dikkatsiz bir sürücü tarafından ezildi."
L.search_dmg_other = "Bu teröristin ölümünün belirli bir nedenini bulamıyorsun."

L.search_weapon = "Görünüşe göre onları öldürmek için bir {weapon} kullanılmış."
L.search_head = "Ölümcül yara bir kafa vuruşuymuş. Çığlık atacak zaman yok."
L.search_time = "Siz aramayı yapmadan yaklaşık {time} önce öldüler."
L.search_dna = "Bir DNA Tarayıcısı ile katilin DNA'sının bir örneğini alın. DNA örneği kabaca {time} sonra bozunacak."

L.search_kills1 = "{player} oyuncusunun ölümünü doğrulayan bir leş listesi buldun."
L.search_kills2 = "Bu adlara sahip bir leş listesi buldunuz:"
L.search_eyes = "Dedektiflik becerilerini kullanarak, {player} adlı oyuncuyu gördükleri son kişi olarak belirledin. Katil ya da bir tesadüf?"


-- Scoreboard
L.sb_playing = "Şu anda oynuyorsunuz..."
L.sb_mapchange = "{num} rauntta veya {time} içinde harita değişecektir."

L.sb_mia = "Eylem Eksik"
L.sb_confirmed = "Onaylanmış Ölü"

L.sb_ping = "Gecikme"
L.sb_deaths = "Ölümler"
L.sb_score = "Puan"
L.sb_karma = "Karma"

L.sb_info_help = "Bu oyuncunun cesedinde arama yapıp sonuçları buradan inceleyebilirsiniz."

L.sb_tag_friend = "ARKADAŞ"
L.sb_tag_susp = "ŞÜPHELİ"
L.sb_tag_avoid = "UZAK DUR"
L.sb_tag_kill = "ÖLDÜR"
L.sb_tag_miss = "KAYIP"

--- Help and settings menu (F1)

L.help_title = "Ayarlar ve Yardım"

-- Tabs
L.help_tut     = "Öğretici"
L.help_tut_tip = "6 adımda TTT"

L.help_settings = "Ayarlar"
L.help_settings_tip = "Kullanıcı tarafı ayarları"

-- Settings
L.set_title_gui = "Arayüz ayarları"

L.set_tips      = "İzlerken ekranın alt kısmında oyun ipuçlarını göster"

L.set_startpopup = "Raunt başlangıç bilgisi açılır pencere süresi"
L.set_startpopup_tip = "Raunt başladığında, ekranınızın altında birkaç saniye boyunca küçük bir açılır pencere görünür. Burada görüntülenen süreyi değiştirin."

L.set_cross_opacity   = "Gez ve arpacık nişangah opaklığı"
L.set_cross_disable   = "Nişangahı tamamen devre dışı bırak"
L.set_minimal_id      = "Nişangah altında Minimalist Hedef Kimliği (karma metin, ipucu vb.)"
L.set_healthlabel     = "Sağlık durumunu sağlık çubuğunda göster"
L.set_lowsights       = "Gez ve arpacık kullanırken silahı indir"
L.set_lowsights_tip   = "Gez ve arpacık kullanırken silah modelini ekranda daha aşağı konumlandırmayı etkinleştir. Bu, hedefinizi görmeyi kolaylaştıracak, ancak daha az gerçekçi görünecektir."
L.set_fastsw          = "Hızlı silah değişme"
L.set_fastsw_tip      = "Silahı kullanmak için tekrar tıklamak zorunda kalmadan silahları dolaştırmayı etkinleştir. Değiştirici menüsünü göstermek için menüyü göster seçeneğini etkinleştirin."
L.set_fastsw_menu     = "Hızlı silah değişme ile menüyü etkinleştir"
L.set_fastswmenu_tip  = "Hızlı silah değişme etkinleştirildiğinde, menü değiştirici menüsü açılır."
L.set_wswitch         = "Silah değişme menüsünü otomatik kapatmayı devre dışı bırak"
L.set_wswitch_tip     = "Varsayılan olarak silah değiştirici, son kaydırmadan birkaç saniye sonra otomatik olarak kapanır. Açık kalması için bunu etkinleştirin."
L.set_cues            = "Bir raunt başladığında veya bittiğinde ses işaretini çal"
L.set_msg_cue         = "Bir bildirim göründüğünde ses işaretini çal"


L.set_title_play    = "Oynanış ayarları"

L.set_specmode      = "Yalnızca İzleme modu (her zaman izleyici olarak kal)"
L.set_specmode_tip  = "Yalnızca İzleme modu, yeni bir raunt başladığında yeniden canlanmanı önleyecek, bunun yerine İzleyici olarak kalacaksın."
L.set_mute          = "Ölüyken canlı oyuncuları sessize al"
L.set_mute_tip      = "Ölüyken/izlerken canlı oyuncuları sessize almayı etkinleştir."


L.set_title_lang    = "Dil ayarları"

-- It may be best to leave this next one english, so english players can always
-- find the language setting even if it's set to a language they don't know.
L.set_lang          = "Dil seç:"


--- Weapons and equipment, HUD and messages

-- Equipment actions, like buying and dropping
L.buy_no_stock = "Silahı bu rauntta aldın ve stoğu tükendi."
L.buy_pending = "Zaten bekleyen bir siparişiniz var, alana kadar bekleyin."
L.buy_received = "Özel ekipmanınızı aldınız."

L.drop_no_room = "Burada silahını bırakacak yerin yok!"

L.disg_turned_on = "Kılık değiştirme etkinleştirildi!"
L.disg_turned_off = "Kılık değiştirme devre dışı."

-- Equipment item descriptions
L.item_passive = "Pasif etki öğesi"
L.item_active = "Aktif kullanım öğesi"
L.item_weapon = "Silah"

L.item_armor = "Vücut Zırhı"
L.item_armor_desc = [[
Vurulduğunda mermi hasarını %30 azaltır.

Dedektifler için varsayılan ekipmandır.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Yaşam belirtilerini taramanızı sağlar. 

Satın alır almaz otomatik taramaları başlatır.
Bu menünün Radar sekmesinde yapılandırabilirsiniz.]]

L.item_disg = "Kılık Değiştirici"
L.item_disg_desc = [[
Açıkken kimlik bilgilerinizi gizler.
Ayrıca bir kurban tarafından en son görülen kişi olmaktan korur. 

Bu menünün Kılık Değiştirme sekmesinde aç/kapat
veya Numpad Enter tuşuna basın.]]

-- C4
L.c4_hint = "Kurmak veya devre dışı bırakmak için {usekey} tuşuna basın."
L.c4_no_disarm    = "Başka bir Hainin C4'ünü Hain ölmedikçe etkisiz hale getiremezsin."
L.c4_disarm_warn = "Kurduğunuz bir C4 patlayıcı etkisiz hale getirildi."
L.c4_armed = "Bombayı başarıyla kurdunuz."
L.c4_disarmed = "Bombayı başarıyla etkisiz hale getirdiniz."
L.c4_no_room = "Bu C4'ü taşıyamazsınız."

L.c4_desc = "Güçlü zaman ayarlı patlayıcı."

L.c4_arm = "C4'ü kur"
L.c4_arm_timer = "Zamanlayıcı"
L.c4_arm_seconds = "Patlamaya saniye kaldı:"
L.c4_arm_attempts = "Etkisiz hale getirme girişimlerinde, 6 telden {num} tanesi kesildiğinde anında patlamaya neden olur."

L.c4_remove_title = "Kaldırma"
L.c4_remove_pickup = "C4'ü al"
L.c4_remove_destroy1 = "C4'ü yok et"
L.c4_remove_destroy2 = "İmhayı onayla"

L.c4_disarm = "C4'ü devre dışı bırak"
L.c4_disarm_cut = "{num} telini kesmek için tıklayın"

L.c4_disarm_t     = "Bombayı etkisiz hale getirmek için bir kablo kesin. Hain olduğun için her kablo güvende. Masumlar için iş o kadar kolay değil!"
L.c4_disarm_owned     = "Bombayı etkisiz hale getirmek için bir kablo kesin. Bu senin bomban, bu yüzden her kablo onu etkisiz hale getirecek."
L.c4_disarm_other    = "Bombayı etkisiz hale getirmek için bir kablo kesin. Yanlış yaparsan patlar!"

L.c4_status_armed = "KURULDU"
L.c4_status_disarmed = "DEVRE DIŞI"

-- Visualizer 
L.vis_name = "Görüntüleyici"
L.vis_hint = "Açmak için {usekey} tuşuna basın (Yalnızca Dedektifler)."

L.vis_help_pri    = "{primaryfire} etkinleştirilen cihazı düşürür."

L.vis_desc = [[
Olay yeri görüntüleme cihazı. 

Kurbanın nasıl öldürüldüğünü göstermek için bir cesedi analiz eder, 
ancak sadece kurşun yaralarından ölmüşlerse işe yarar.]]

-- Decoy
L.decoy_name = "Tuzak"
L.decoy_no_room = "Bu tuzağı taşıyamazsınız."
L.decoy_broken = "Tuzağınız yok edildi!"

L.decoy_help_pri  = "{primaryfire} tuzağı yerleştirir."

L.decoy_desc = [[
Dedektiflere sahte bir radar işareti gösterir, 
ve DNA tarayıcıları 
DNA'nızı taradıkları takdirde yemin yerini göstermesini sağlar
.]]

-- Defuser
L.defuser_name = "İmha Kiti"
L.defuser_help = "{primaryfire}, hedef C4'ü etkisiz hale getirir."

L.defuser_desc = [[
Bir C4 patlayıcısını anında etkisiz hale getirin. 

Sınırsız kullanım. Bunu taşırsanız 
C4'ü fark etmeniz daha kolay olacak.]]

-- Flare gun
L.flare_name = "İşaret fişeği tabancası"
L.flare_desc = [[
Cesetleri yakmak için kullanılabilir, böylece 
asla bulunmazlar. Sınırlı cephane. 

Bir cesedi yakmak belirgin bir ses çıkarır
.]]

-- Health station
L.hstation_name = "Sağlık İstasyonu"
L.hstation_hint   = "Sağlık almak için {usekey} tuşuna bas. Şarj: {num}."
L.hstation_broken = "Sağlık İstasyonun yok edildi!"
L.hstation_help = "{primaryfire} Sağlık İstasyonunu yerleştirir."

L.hstation_desc = [[
Yerleştirildiğinde insanların iyileşmesini sağlar. 

Yavaş şarj. Herkes kullanabilir ve 
hasar verilebilir. Kullanıcılarının DNA 
örnekleri için kontrol edilebilir.]]

-- Knife
L.knife_name = "Bıçak"
L.knife_thrown = "Fırlatılan bıçak"

L.knife_desc = [[
Yaralı hedefleri anında sessiz bir şekilde öldürür
, ancak sadece tek bir kullanımı vardır. 

Alternatif ateş kullanılarak atılabilir.]]

-- Poltergeist
L.polter_desc = [[
Katilleri nesnelere yapıştırıp 
sağ sola şiddetle savurur. 

Enerji patlamaları yakındaki 
insanlara zarar verir.]]

-- Radio
L.radio_broken = "Radyonuz yok edildi!"
L.radio_help_pri = "{primaryfire} radyoyu yerleştirir."

L.radio_desc = [[
Dikkat dağıtmak veya şaşırtmak için sesler çıkarır. 

Radyoyu bir yere yerleştirin ve 
radyo sekmesini kullanarak bu menüde sesleri çal.]]

-- Silenced pistol
L.sipistol_name = "Susturuculu Tabanca"

L.sipistol_desc = [[
Düşük gürültülü tabanca, normal tabanca mermisi kullanır.
Kurbanlar öldürüldüklerinde çığlık atmazlar.]]

-- Newton launcher
L.newton_name = "Newton fırlatıcı"

L.newton_desc = [[
İnsanları güvenli bir mesafeden itin. 

Sonsuz cephane, ama ateş etmesi yavaş.]]

-- Binoculars
L.binoc_name = "Dürbün"
L.binoc_desc = [[
Cesetleri yakınlaştır ve onları 
uzak bir mesafeden teşhis edin. 

Sınırsız kullanım, ancak teşhis etme 
birkaç saniye sürer.]]

L.binoc_help_pri  = "{primaryfire} bir cesedi teşhis eder."
L.binoc_help_sec  = "{secondaryfire} yakınlaştırma seviyesini değiştirir."

-- UMP
L.ump_desc = [[
Hedeflerin kafasını karıştıran deneysel 
SMG. 

Standart SMG cephanesi kullanır.]]

-- DNA scanner
L.dna_name = "DNA tarayıcı"
L.dna_identify    = "Katilin DNA'sını almak için ceset teşhis edilmelidir."
L.dna_notfound = "Hedefte DNA örneği bulunamadı."
L.dna_limit = "Depolama sınırına ulaşıldı. Yenilerini eklemek için eski numuneleri kaldırın."
L.dna_decayed = "Katilin DNA örneği çürümüş."
L.dna_killer = "Cesetten katilin DNA'sından bir örnek toplandı!"
L.dna_no_killer = "DNA alınamadı (katil bağlantıyı kesti?)."
L.dna_armed = "Bu bomba aktif! Önce onu etkisiz hale getir!"
L.dna_object      = "Nesneden {num} yeni DNA örneği toplandı."
L.dna_gone = "Bölgede DNA tespit edilmedi."

L.dna_desc = [[
Nesnelerden DNA örnekleri toplayın 
ve bunları DNA'nın sahibini bulmak için kullanın. 

Katilin DNA'sını almak için taze cesetler üzerinde kullanın
ve onları takip edin.]]

L.dna_menu_title  = "DNA tarama kontrolleri"
L.dna_menu_sample = "{source} üzerinde bulunan DNA örneği"
L.dna_menu_remove = "Seçilenleri kaldır"
L.dna_menu_help1  = "Bunlar topladığın DNA örnekleri."
L.dna_menu_help2 = [[
Şarj olduğunda, DNA örneğinin ait olduğu 
oyuncunun konumunu tarayabilirsiniz. 
Uzak hedefleri bulmak daha fazla enerji tüketir.]]

L.dna_menu_scan   = "Tara"
L.dna_menu_repeat = "Otomatik tekrarla"
L.dna_menu_ready  = "HAZIR"
L.dna_menu_charge = "ŞARJ OLUYOR"
L.dna_menu_select = "NUMUNE SEÇ"

L.dna_help_primary   = "DNA örneği almak için {primaryfire}"
L.dna_help_secondary = "Tarama kontrollerini açmak için {secondaryfire}"

-- Magneto stick
L.magnet_name = "Manyeto çubuğu"
L.magnet_help = "Cesedi yüzeye tutturmak için {primaryfire}"

-- Grenades and misc
L.grenade_smoke = "Duman bombası"
L.grenade_fire = "Yakıcı bomba"

L.unarmed_name = "Gizlendi"
L.crowbar_name = "Levye"
L.pistol_name = "Tabanca"
L.rifle_name = "Tüfek"
L.shotgun_name = "Pompalı tüfek"

-- Teleporter
L.tele_name = "Işınlayıcı"
L.tele_failed = "Işınlama başarısız oldu."
L.tele_marked = "Işınlanma konumu işaretlendi."

L.tele_no_ground = "Sağlam bir zemin üzerinde durmadan ışınlanamazsın!"
L.tele_no_crouch = "Çömelmişken ışınlanamazsın!"
L.tele_no_mark = "Konum işaretlenmedi. Işınlanmadan önce varış noktasını işaretleyin."

L.tele_no_mark_ground = "Sağlam bir zemin üzerinde durmadan ışınlanamazsın!"
L.tele_no_mark_crouch = "Çömelmişken ışınlanma konumu işaretlenemez!"

L.tele_help_pri = "{primaryfire} işaretli konuma ışınlar."
L.tele_help_sec   = "{secondaryfire} mevcut konumu işaretler."

L.tele_desc = [[
Daha önce işaretlenmiş bir noktaya ışınlanın. 

Işınlanma ses çıkarır ve 
kullanım sayısı sınırlıdır.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm cephanesi"

L.ammo_smg1 = "SMG cephanesi"
L.ammo_buckshot = "Pompalı tüfek cephanesi"
L.ammo_357 = "Tüfek cephanesi"
L.ammo_alyxgun = "Deagle cephanesi"
L.ammo_ar2altfire = "İşaret fişeği cephanesi"
L.ammo_gravity = "Poltergeist cephanesi"


--- HUD interface text

-- Round status
L.round_wait = "Bekleniyor"
L.round_prep = "Hazırlanıyor"
L.round_active = "Devam etmekte"
L.round_post = "Raunt bitti"

-- Health, ammo and time area
L.overtime = "UZATMA"
L.hastemode = "HIZLI MOD"

-- TargetID health status
L.hp_healthy = "Sağlıklı"
L.hp_hurt = "Hasar Görmüş"
L.hp_wounded = "Yaralı"
L.hp_badwnd = "Kötü Yaralanmış"
L.hp_death = "Ölüme Yakın"


-- TargetID Karma status
L.karma_max = "Saygın"
L.karma_high = "İyi"
L.karma_med = "Tetik Çekmeye Hazır"
L.karma_low = "Tehlikeli"
L.karma_min = "Sorumsuz"

-- TargetID MISC
L.corpse = "Ceset"
L.corpse_hint = "Arama yapmak için [{usekey}] tuşuna basın. Gizlice arama yapmak için [{walkkey}+{usekey}]."

L.target_disg = "(GİZLENMİŞ}"
L.target_unid = "Tanımlanmamış ceset"

L.target_traitor = "HAİN ARKADAŞ"
L.target_detective = "DEDEKTİF"

L.target_credits = "Harcanmamış kredileri almak için arama yapın"

-- Traitor buttons (HUD buttons with hand icons that only traitors can see)
L.tbut_single = "Tek kullanımlık"
L.tbut_reuse = "Yeniden kullanılabilir"
L.tbut_retime  = "{num} saniye sonra yeniden kullanılabilir"
L.tbut_help    = "Etkinleştirmek için {key} tuşuna basın"

-- Equipment info lines (on the left above the health/ammo panel)
L.disg_hud     = "Gizlenmiş. Adınız gizlidir."
L.radar_hud    = "Radar bir sonraki tarama için {time} içinde hazır"

-- Canlı/ölü -- Spectator muting of living/dead sessize alınması
L.mute_living = "Canlı oyuncular sessize alındı"
L.mute_specs = "İzleyiciler sessize alındı"
L.mute_all = "Tümü sessize alındı"
L.mute_off = "Kimse sessize alınmadı"

-- Spectators and prop possession
L.punch_title = "GÜÇ ÖLÇER"
L.punch_help   = "Hareket tuşları veya zıpla ile nesneyi yumrukla. Çömelerek nesneyi bırak."
L.punch_bonus = "Kötü puanınız güç ölçer sınırınızı {num} düşürdü."
L.punch_malus = "İyi puanın güç ölçer sınırını {num} arttırdı!"

L.spec_help    = "Oyuncuları izlemek için tıkla veya bir fizik nesnesine sahip olmak için {usekey} tuşuna bas."

-- Info popups shown when the round starts

-- These are spread over multiple lines, hence the square brackets instead of
-- quotes. That's a Lua thing. Every line break (enter) will show up in-game.
L.info_popup_innocent = [[Sen masum bir Teröristsin ama etrafta hainler var... 
Kime güvenebilirsin ve seni kurşuna dizmek isteyen kim olabilir? 

Arkanı kolla ve bu işten canlı çıkmak için yoldaşlarınla birlikte çalış!]]

L.info_popup_detective = [[Dedektifsiniz! Terörist Karargahı, hainleri bulman için sana özel kaynaklar verdi. 
Masumların hayatta kalmasını sağlamak için bunları kullanın, ancak dikkatli olun 
hainler önce seni alaşağı etmek isteyecekler! 

Ekipmanınızı almak için {menukey} tuşuna basın!]]

L.info_popup_traitor_alone = [[Sen bir HAİNSİN! Bu rauntta hain arkadaşın yok. 

Kazanmak için diğerlerini öldür!

Ekipmanınızı almak için {menukey} tuşuna basın!]]

L.info_popup_traitor = [[Sen bir HAİNSİN! Diğerlerini öldürmek için diğer hainlerle birlikte çalışın. 
Kendine iyi bak, yoksa hainliğin ortaya çıkabilir... 

Bunlar senin yoldaşların 
{traitorlist}.

 Ekipmanınızı almak için {menukey} tuşuna basın!]]

-- Various other text
L.name_kick = "Rauntta bir oyuncu ismini değiştirdiği için otomatik olarak atıldı."

L.idle_popup = [[{num} saniye boyunca boştaydın ve sonuç olarak yalnızca İzleyici moduna geçtin. Bu moddayken, yeni bir raunt başladığında oyuna başlamayacaksın.

{helpkey} tuşuna basarak ve Ayarlar sekmesindeki kutunun işaretini kaldırarak istediğiniz zaman İzleyici modunu değiştirebilirsiniz. Ayrıca şu anda devre dışı bırakmayı da seçebilirsiniz.]]

L.idle_popup_close = "Hiçbir şey yapma"
L.idle_popup_off = "İzleyici modunu şimdi devre dışı bırak"

L.idle_warning = "Uyarı: Boşta/AFK gibi görünüyorsunuz ve etkinlik göstermediğiniz sürece izlemeye alınacaksınız!"

L.spec_mode_warning = "İzleyici modundasın ve bir raunt başladığında oyuna başlamayacaksın. Bu modu devre dışı bırakmak için F1'e basın, 'Oynanış'a gidin ve 'Yalnızca İzle modu'nun işaretini kaldırın."


--- Tips, shown at bottom of screen to spectators

-- Tips panel
L.tips_panel_title = "İpuçları"
L.tips_panel_tip = "İpucu:"

-- Tip texts

L.tip1 = "Hainler, {walkkey} tuşunu basılı tutarak ve {usekey} tuşuna basarak, ölümü onaylamadan bir cesedi sessizce arayabilirler."

L.tip2 = "Bir C4 patlayıcısını daha uzun bir zamanlayıcıyla donatmak, masum biri onu etkisiz hale getirmeye çalıştığında anında patlamasına neden olan tellerin sayısını artıracaktır. Ayrıca daha yumuşak ve daha az sıklıkta bip sesi çıkaracaktır."

L.tip3 = "Dedektifler, 'gözlerine yansıyanı' bulmak için bir cesedi arayabilirler. Bu, ölünün gördüğü son kişi. Arkadan vurulduysa katil olmak zorunda değil."

L.tip4 = "Kimse cesedinizi bulana ve sizi arayarak teşhis edene kadar öldüğünüzü bilmeyecek."

L.tip5 = "Bir Hain bir Dedektifi öldürdüğünde, anında bir kredi ödülü alır."

L.tip6 = "Bir Hain öldüğünde, tüm Dedektifler ekipman kredisi ile ödüllendirilir."

L.tip7 = "Hainler masumları öldürmede önemli ilerleme kaydettiklerinde, ödül olarak bir ekipman kredisi alacaklar."

L.tip8 = "Hainler ve Dedektifler, diğer Hainlerin ve Dedektiflerin cesetlerinden harcanmamış ekipman kredileri toplayabilir."

L.tip9 = "Poltergeist herhangi bir fizik nesnesini ölümcül bir mermiye dönüştürebilir. Her çarpışmada, yakındaki herkese zarar veren bir enerji patlaması eşlik eder."

L.tip10 = "Hain veya Dedektifseniz, sağ üstteki kırmızı mesajlara dikkat edin. Bunlar sizin için önemli olacak."

L.tip11 = "Hain veya Dedektif olarak, siz ve yoldaşlarınız iyi performans gösterirseniz ekstra ekipman kredisi ile ödüllendirileceğinizi unutmayın. Harcamayı unutmayın!"

L.tip12 = "Dedektiflerin DNA Tarayıcısı, silahlardan ve öğelerden DNA örnekleri toplamak ve daha sonra bunları kullanan oyuncunun yerini bulmak için tarama yapmak için kullanılabilir. Bir cesetten veya etkisiz hale getirilmiş bir C4'ten numune alabildiğinizde kullanışlıdır!"

L.tip13 = "Öldürdüğünüz birine yakın olduğunuzda, DNA'nızın bir kısmı cesedin üzerinde kalır. Bu DNA, mevcut konumunuzu bulmak için bir Dedektifin DNA Tarayıcısı ile kullanılabilir. Birini bıçakladıktan sonra cesedi saklasan iyi olur!"

L.tip14 = "Öldürdüğünüz birinden ne kadar uzaktaysanız, cesetteki DNA örneğiniz o kadar hızlı bozulur."

L.tip15 = "Hain misin, keskin nişancılık mı yapıyorsun? Kılık Değiştiriciyi denemeyi düşünün. Bir atışı kaçırırsan, güvenli bir yere kaç, Kılık Değiştiriciyi devre dışı bırak ve hiç kimse onlara ateş edenin sen olduğunu bilmeyecek."

L.tip16 = "Hain olarak Işınlayıcı, kovalandığında kaçmana yardımcı olabilir ve büyük bir harita üzerinde hızlı bir şekilde seyahat etmeni sağlar. Her zaman işaretli güvenli bir pozisyonunuz olduğundan emin olun."

L.tip17 = "Masumların hepsi gruplanmış ve yakalanması zor mu? C4'ün seslerini çalmak için Radyoyu veya onları uzaklaştırmak için bir ateş etmeyi denemeyi düşünün."

L.tip18 = "Radyoyu Hainken, radyo yerleştirildikten sonra Ekipman Menünüzden sesleri çalabilirsiniz. İstediğiniz sırayla birden fazla düğmeye tıklayarak birden fazla sesi sıraya koyun."

L.tip19 = "Dedektifken, kalan kredileriniz varsa, güvenilir bir Masuma İmha Kiti verebilirsiniz. O zaman zamanınızı ciddi araştırma çalışmaları yaparak geçirebilir ve riskli bomba imha işini onlara bırakabilirsiniz."

L.tip20 = "Dedektiflerin Dürbünü, cesetlerin uzun menzilli aranmasına ve tanımlanmasına izin verir. Hainler bir cesedi yem olarak kullanmayı umuyorsa kötü haber. Elbette, Dürbünü kullanırken bir Dedektif silahsızdır ve dikkati dağılır..."

L.tip21 = "Dedektiflerin Sağlık İstasyonu, yaralı oyuncuların iyileşmesini sağlar. Tabii o yaralılar da Hain olabilir..."

L.tip22 = "Sağlık İstasyonu, onu kullanan herkesin DNA örneğini kaydeder. Dedektifler bunu DNA Tarayıcısı ile kimin iyileştiğini bulmak için kullanabilirler."

L.tip23 = "Silahlar ve C4'ten farklı olarak, Hainler için Radyo ekipmanı, onu yerleştiren kişinin DNA örneğini içermez. Dedektiflerin onu bulması ve kimliğini ifşa etmesi konusunda endişelenme."

L.tip24 = "Kısa bir öğreticiyi görüntülemek veya TTT'ye özgü bazı ayarları değiştirmek için {helpkey} tuşuna basın. Örneğin, bu ipuçlarını kalıcı olarak devre dışı bırakabilirsiniz."

L.tip25 = "Dedektif bir cesedi aradığında, sonuç ölü kişinin adına tıklayarak puan tablosu aracılığıyla tüm oyuncuların kullanımına açıktır."

L.tip26 = "Puan tablosunda, birinin adının yanındaki büyüteç simgesi, o kişi hakkında arama bilgilerine sahip olduğunuzu gösterir. Simge parlaksa, veriler bir Dedektiften gelir ve ek bilgiler içerebilir."

L.tip27 = "Dedektif olarak, takma addan sonra büyüteç takılan cesetler bir Dedektif tarafından aranmıştır ve sonuçları puan tablosu aracılığıyla tüm oyunculara açıktır."

L.tip28 = "İzleyiciler, diğer izleyicileri veya yaşayan oyuncuları susturmak için {mutekey} tuşuna basabilir."

L.tip29 = "Sunucu ek diller yüklediyse, Ayarlar menüsünden istediğiniz zaman farklı bir dile geçebilirsiniz."

L.tip30 = "Hızlı sohbet veya 'radyo' komutları {zoomkey} tuşuna basılarak kullanılabilir."

L.tip31 = "İzleyiciyken, fare imlecinin kilidini açmak için {duckkey} tuşuna bas ve bu ipuçları panelindeki düğmelere tıkla. Fare görünümüne geri dönmek için {duckkey} tuşuna tekrar basın."

L.tip32 = "Levyenin ikincil ateşi diğer oyuncuları itecektir."

L.tip33 = "Gez ve arpacığı kullanarak ateş etmek, isabetini biraz artıracak ve geri tepmeyi azaltacaktır. Çömelmek işe yaramaz."

L.tip34 = "Duman bombaları, özellikle kalabalık odalarda ve iç mekanlarda kafa karışıklığı yaratmak için etkilidir."

L.tip35 = "Hain olarak, cesetleri taşıyabileceğinizi ve onları masumların ve Dedektiflerinin meraklı gözlerinden saklayabileceğinizi unutmayın."

L.tip36 = "{helpkey} altında bulunan öğretici, oyunun en önemli ince ayrıntılarına genel bir bakış içerir."

L.tip37 = "Puan tablosunda, yaşayan bir oyuncunun adına tıklayıp 'şüpheli' veya 'arkadaş' gibi bir etiket seçebilirsiniz. Bu etiket, nişangahınızın altındaysa görünecektir."

L.tip38 = "Yerleştirilebilir ekipman öğelerinin çoğu (C4, Radyo gibi) ikincil ateş kullanılarak duvarlara yapıştırılabilir."

L.tip39 = "Etkisiz hale getirilirken bir hata nedeniyle patlayan C4, zamanlayıcısında sıfıra ulaşan C4'ten daha küçük bir patlamaya sahiptir."

L.tip40 = "Raunt zamanlayıcısının üzerinde 'HIZLI MOD' yazıyorsa, raunt ilk başta sadece birkaç dakika uzunluğunda olacaktır, ancak her ölümle birlikte mevcut süre artar (TF2'deki bir noktayı yakalamak gibi). Bu mod, hainlere işlerini devam ettirmeleri için baskı yapar."

-- Round report

L.report_title = "Raunt Raporu"

-- Tabs
L.report_tab_hilite = "Öne Çıkanlar"
L.report_tab_hilite_tip = "Rauntta Öne Çıkanlar"
L.report_tab_events = "Olaylar"
L.report_tab_events_tip = "Bu raunt gerçekleşen olayların kaydı"
L.report_tab_scores = "Puanlar"
L.report_tab_scores_tip = "Sadece bu rauntta her oyuncunun aldığı puan"

-- Event log saving
L.report_save = "Kaydı .txt olarak kaydet"
L.report_save_tip = "Olay Kaydını bir metin dosyasına kaydeder"
L.report_save_error = "Kaydedilecek Olay Kaydı verisi yok."
L.report_save_result = "Olay Kaydı şuraya kaydedildi:"

-- Big title window
L.hilite_win_traitors = "HAİNLER KAZANDI"
L.hilite_win_innocent = "MASUMLAR KAZANDI"

L.hilite_players1 = "{numplayers} oyuncu vardı, {numtraitors} kadarı haindi"
L.hilite_players2 = "{numplayers} oyuncu vardı, biri haindi"

L.hilite_duration = "Raunt {time} sürdü"

-- Columns
L.col_time = "Zaman"
L.col_event = "Olay"
L.col_player = "Oyuncu"
L.col_role   = "Rol"
L.col_kills1 = "Masum öldürmeleri"
L.col_kills2 = "Hain öldürmeleri"
L.col_points = "Puanlar"
L.col_team = "Takım bonusu"
L.col_total = "Toplam puan"

-- Name of a trap that killed us that has not been named by the mapper
L.something      = "bir şey"

-- Kill events
L.ev_blowup      = "{victim} kendini havaya uçurdu"
L.ev_blowup_trap = "{victim} {trap} tarafından havaya uçuruldu"

L.ev_tele_self   = "{victim} kendilerini ışınlayarak öldürdü"
L.ev_sui         = "{victim} bunu kaldıramadı ve kendini öldürdü"
L.ev_sui_using   = "{victim}, {tool} kullanarak kendini öldürdü"

L.ev_fall        = "{victim} ölümüne düştü"
L.ev_fall_pushed = "{victim}, {attacker} onları ittikten sonra ölümüne düştü"
L.ev_fall_pushed_using = "{victim}, {attacker} onları itmek için {trap} kullandıktan sonra ölümüne düştü "

L.ev_shot        = "{victim} {attacker} tarafından vuruldu"
L.ev_shot_using  = "{victim} bir {weapon} kullanarak {attacker} tarafından vuruldu"

L.ev_drown       = "{victim}, {attacker} tarafından boğuldu"
L.ev_drown_using = "{victim}, {attacker} tarafından tetiklenen {trap} tarafından boğuldu"

L.ev_boom        = "{victim}, {attacker} tarafından patlatıldı"
L.ev_boom_using  = "{victim}, {trap} kullanılarak {attacker} tarafından havaya uçuruldu "

L.ev_burn        = "{victim} {attacker} tarafından kızartıldı"
L.ev_burn_using  = "{victim}, {attacker} nedeniyle {trap} tarafından yakıldı"

L.ev_club        = "{victim}, {attacker} tarafından dövüldü"
L.ev_club_using  = "{victim}, {trap} kullanılarak {attacker} tarafından dövülerek öldürüldü"

L.ev_slash       = "{kurban}, {saldırgan} tarafından bıçaklandı"
L.ev_slash_using = "{victim}, {trap} kullanılarak {attacker} tarafından kesildi"

L.ev_tele        = "{victim} {attacker} tarafından ışınlanarak öldürüldü"
L.ev_tele_using  = "{victim}, {attacker} tarafından ayarlanan {trap} tarafından atomize edildi"

L.ev_goomba      = "{victim}, {attacker} ağır cüssesiyle ezildi"

L.ev_crush       = "{victim}, {attacker} tarafından ezildi"
L.ev_crush_using = "{victim}, {attacker} oyuncusunun {trap} tuzağı ile ezildi"

L.ev_other       = "{victim}, {attacker} tarafından öldürüldü"
L.ev_other_using = "{victim}, {trap} kullanılarak {attacker} tarafından öldürüldü"

-- Other events
L.ev_body        = "{victim} cesedini {finder} buldu"
L.ev_c4_plant    = "C4'ü {player} kurdu"
L.ev_c4_boom     = "{player} tarafından kurulan C4 patladı"
L.ev_c4_disarm1  = "{player}, {owner} tarafından kurulan C4'ü etkisiz hale getirdi"
L.ev_c4_disarm2  = "{player}, {owner} tarafından kurulan C4'ü etkisiz hale getiremedi"
L.ev_credit      = "{finder}, {player} adlı oyuncunun cesedinde {num} kredi buldu"

L.ev_start       = "Raunt başladı"
L.ev_win_traitor = "Aşağılık hainler raundu kazandı!"
L.ev_win_inno    = "Sevimli masum teröristler raundu kazandı!"
L.ev_win_time    = "Hainlerin zamanı tükendi ve kaybettiler!"

--- Awards/highlights

L.aw_sui1_title = "İntihar Kültü Lideri"
L.aw_sui1_text = "ilk giden olarak diğer intihar edenlere nasıl yapılacağını gösterdi."

L.aw_sui2_title = "Yalnız ve Depresyonda"
L.aw_sui2_text = "kendini öldüren tek kişiydi."

L.aw_exp1_title = "Patlayıcı Araştırma Hibesi"
L.aw_exp1_text = "patlamalar üzerine yaptıkları araştırmalarla tanındı. {num} denek yardımcı oldu."

L.aw_exp2_title = "Saha Araştırması"
L.aw_exp2_text = "patlamalara karşı kendi dirençlerini test etti. Yeterince yüksek değildi."

L.aw_fst1_title = "İlk Kan"
L.aw_fst1_text = "bir hainin elindeki ilk masum ölümü teslim etti."

L.aw_fst2_title = "İlk Kanlı Aptal Öldürme"
L.aw_fst2_text = "bir hain dostunu vurarak ilk cinayeti işledi. Aferin."

L.aw_fst3_title = "İlk Hatacı"
L.aw_fst3_text = "ilk öldüren oldu. Masum bir yoldaş olması çok kötü oldu."

L.aw_fst4_title = "İlk Darbe"
L.aw_fst4_text = "ilk ölümü hainin yaparak masum teröristlere ilk darbeyi vurdu."

L.aw_all1_title = "Eşitler Arasında En Ölümcül"
L.aw_all1_text = "bu rauntta masumlar tarafından yapılan her cinayetten sorumluydu."

L.aw_all2_title = "Yalnız Kurt"
L.aw_all2_text = "bu rauntta bir hain tarafından yapılan her cinayetten sorumluydu."

L.aw_nkt1_title = "Birini Aldım Patron!"
L.aw_nkt1_text = "tek bir masumu öldürmeyi başardı. Güzel!"

L.aw_nkt2_title = "İki Kişilik Kurşun"
L.aw_nkt2_text = "ilkinin bir başkasını öldürerek şanslı bir atış olmadığını gösterdi."

L.aw_nkt3_title = "Seri Hain"
L.aw_nkt3_text = "bugün üç masumun terörizm hayatına son verdi."

L.aw_nkt4_title = "Daha Fazla Koyun Benzeri Kurt Arasında Kurt"
L.aw_nkt4_text = "Masum teröristleri akşam yemeğinde yer. {num} yemekten oluşan bir akşam yemeği."

L.aw_nkt5_title = "Terörle Mücadele Operatörü"
L.aw_nkt5_text = "öldürme başına ödeme alır. Artık başka bir lüks yat satın alabilir."

L.aw_nki1_title = "Buna İhanet Et"
L.aw_nki1_text = "bir hain buldu. Bir haini vurdu. Kolaydı."

L.aw_nki2_title = "Adalet Ekibine Müracaat Edildi"
L.aw_nki2_text = "iki haine büyük öteye kadar eşlik etti."

L.aw_nki3_title = "Hainler Hain Koyun Düşler mi?"
L.aw_nki3_text = "üç haine tatlı rüyalar gördür."

L.aw_nki4_title = "İçişleri Çalışanı"
L.aw_nki4_text = "öldürme başına ödeme alır. Artık beşinci yüzme havuzunu sipariş edebilir."

L.aw_fal1_title = "Hayır Bay Bond, Düşmenizi Bekliyorum"
L.aw_fal1_text = "birini büyük bir yükseklikten itti."

L.aw_fal2_title = "Dümdüz"
L.aw_fal2_text = "kayda değer bir yükseklikten düştükten sonra bedeninin yere çarpmasına izin verdi."

L.aw_fal3_title = "İnsan Göktaşı"
L.aw_fal3_text = "büyük bir yükseklikten birinin üstüne düşerek ezdi."

L.aw_hed1_title = "Verimlilik"
L.aw_hed1_text = "kafadan vurma sevincini keşfetti ve {num} kazandı."

L.aw_hed2_title = "Nöroloji"
L.aw_hed2_text = "daha yakından incelemek için beyinleri {num} kafadan çıkardı."

L.aw_hed3_title = "Video Oyunları Bana Zorla Yaptırdı"
L.aw_hed3_text = "cinayet simülasyonu eğitimini uyguladı ve {num} düşmanı kafadan vurdu."

L.aw_cbr1_title = "Sırra Kadem Bas"
L.aw_cbr1_text = "levyeyi gelişigüzel sallar ve bunu {num} kurban öğrenir."

L.aw_cbr2_title = "Freeman"
L.aw_cbr2_text = "levyelerini en az {num} kişinin beynine sapladı."

L.aw_pst1_title = "Israrcı Küçük Alçak"
L.aw_pst1_text = "tabancayı kullanarak {num} kişi öldürdü. Sonra birine ölümüne sarılmaya devam ettiler."

L.aw_pst2_title = "Küçük Kalibreli Kesim"
L.aw_pst2_text = "{num} kişilik küçük bir orduyu tabancayla öldürdü. Muhtemelen namlunun içine küçük bir av tüfeği yerleştirdi."

L.aw_sgn1_title = "Kolay Mod"
L.aw_sgn1_text = "iri saçmayı acıdığı yere uygulayarak {num} hedefi öldürür."

L.aw_sgn2_title = "Bin Küçük Saçma Tanesi"
L.aw_sgn2_text = "saçmalarını gerçekten beğenmedi, bu yüzden hepsini verdiler. {num} alıcı bundan zevk alacak kadar yaşamadı."

L.aw_rfl1_title = "İşaretle ve Tıkla"
L.aw_rfl1_text = "{num} öldürme için ihtiyacın olan tek şeyin bir tüfek ve titremeyen bir el olduğunu gösterir."

L.aw_rfl2_title = "Kafanı Buradan Görebiliyorum"
L.aw_rfl2_text = "tüfeğini biliyor. Şimdi {num} kişi daha tüfeği biliyor."

L.aw_dgl1_title = "Küçük Bir Tüfek Gibi"
L.aw_dgl1_text = "Desert Eagle'a alışıp {num} kişiyi öldürdü."

L.aw_dgl2_title = "Deagle Ustası"
L.aw_dgl2_text = "{num} kişiyi deagle ile darmadağın etti."

L.aw_mac1_title = "Dua Et ve Öldür"
L.aw_mac1_text = "MAC10 ile {num} kişiyi öldürdü, ama öldürmek için ne kadar mermiye ihtiyaç duyduğunu söylemeyecek."

L.aw_mac2_title = "Gülümse ve Seyret"
L.aw_mac2_text = "iki MAC10 kullanabilseler ne olacağını merak ediyor. {num} çarpı iki?"

L.aw_sip1_title = "Sessiz Ol"
L.aw_sip1_text = "{num} kişiyi susturulmuş tabancayla sustur."

L.aw_sip2_title = "Susturulmuş Suikastçı"
L.aw_sip2_text = "kendini ölürken duymayan {num} kişiyi öldürdü."

L.aw_knf1_title = "Seni Bilen Bıçak"
L.aw_knf1_text = "internet üzerinden birini yüzünden bıçakladı."

L.aw_knf2_title = "Bunu Nereden Aldın?"
L.aw_knf2_text = "bir Hain değildi, ama yine de bıçakla birini öldürdü."

L.aw_knf3_title = "Böyle Bir Bıçak Adam"
L.aw_knf3_text = "etrafta {num} bıçak buldu ve bunlardan faydalandı."

L.aw_knf4_title = "Dünyanın En Bıçak Adamı"
L.aw_knf4_text = "{num} kişiyi bıçakla öldürdü. Nasıl olduğunu sorma."

L.aw_flg1_title = "Kurtarmaya"
L.aw_flg1_text = "işaret fişeklerini {num} ölüm sinyali vermek için kullandı."

L.aw_flg2_title = "İşaret Fişeği Ateşi Gösterir"
L.aw_flg2_text = "{num} erkeğe yanıcı kıyafet giymenin tehlikesini öğretti."

L.aw_hug1_title = "H.U.G.E Felaketi"
L.aw_hug1_text = "H.U.G.E.'leriyle uyumluydu, bir şekilde mermilerini {num} kişiye isabet ettirmeyi başardı."

L.aw_hug2_title = "Sabırlı Er"
L.aw_hug2_text = "sadece ateş etmeye devam etti ve H.U.G.E.'nin sabrının {num} öldürme ile ödüllendirildiğini gördü."

L.aw_msx1_title = "Bam Bam Bam"
L.aw_msx1_text = "M16 ile {num} kişiyi öldürdü."

L.aw_msx2_title = "Orta Menzil Çılgınlığı"
L.aw_msx2_text = "M16 ile hedefleri nasıl indireceğini bilir ve {num} düşman öldürür."

L.aw_tkl1_title = "Sakar Şakir"
L.aw_tkl1_text = "tam bir arkadaşa nişan alırken parmakları kaydı."

L.aw_tkl2_title = "Çifte Sakar Şakir"
L.aw_tkl2_text = "iki kez Hain aldıklarını düşündüler, ancak her iki seferde de yanıldılar."

L.aw_tkl3_title = "Karma bilincine sahip"
L.aw_tkl3_text = "iki takım arkadaşını öldürdükten sonra duramadı. Üç onların uğurlu sayısıdır."

L.aw_tkl4_title = "Takım Katili"
L.aw_tkl4_text = "tüm takımını öldürdü. ALLAH'INI SEVEN BANLASIN."

L.aw_tkl5_title = "Rol Oyuncusu"
L.aw_tkl5_text = "deli bir adamı canlandırıyordu, gerçekten. Bu yüzden takımlarının çoğunu öldürdüler."

L.aw_tkl6_title = "Aptal"
L.aw_tkl6_text = "hangi tarafta olduklarını anlayamadılar ve yoldaşlarının yarısından fazlasını öldürdüler."

L.aw_tkl7_title = "Cahil"
L.aw_tkl7_text = "takım arkadaşlarının dörtte birinden fazlasını öldürerek bölgelerini gerçekten iyi korudu."

L.aw_brn1_title = "Eskiden Büyükannemin Yaptığı Gibi"
L.aw_brn1_text = "birkaç kişiyi güzelce kızarttı."

L.aw_brn2_title = "Kundakçı"
L.aw_brn2_text = "kurbanlarından birini yaktıktan sonra yüksek sesle kıkırdadığı duyuldu."

L.aw_brn3_title = "Kundakçının Ateşi Söner"
L.aw_brn3_text = "hepsini yaktı, ama şimdi hiç yakıcı el bombası kalmadı! Nasıl başa çıkacaklar!?"

L.aw_fnd1_title = "Adli tabip"
L.aw_fnd1_text = "etrafta {num} ceset buldu."

L.aw_fnd2_title = "Hepsini Yakalamalıyım"
L.aw_fnd2_text = "koleksiyonları için {num} ceset buldu."

L.aw_fnd3_title = "Ölüm Kokusu"
L.aw_fnd3_text = "bu rauntta {num} kez rastgele cesetler üzerinde tökezler."

L.aw_crd1_title = "Geri Dönüştürücü"
L.aw_crd1_text = "cesetlerden {num} kredi toplandı."

L.aw_tod1_title = "Kundakçının Zaferi"
L.aw_tod1_text = "takımları raundu kazanmadan sadece saniyeler önce öldü."

L.aw_tod2_title = "Bu Oyundan Nefret Ediyorum"
L.aw_tod2_text = "raundun başlamasından hemen sonra öldü."


-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.


--- v23
L.set_avoid_det     = "Dedektif olarak seçilmekten kaçın"
L.set_avoid_det_tip = "Sunucunun mümkünse sizi Dedektif olarak seçmemesini istemek için bunu etkinleştirin. Bu daha sık Hain olduğun anlamına gelmez."

-- v24
L.drop_no_ammo = "Silahının şarjöründe cephane kutusu olarak düşecek yeterli cephane yok."

--- v31
L.set_cross_brightness = "Nişangah parlaklığı"
L.set_cross_size = "Nişangah boyutu"

-- 2015-05-25
L.hat_retrieve = "Bir Dedektif'in şapkasını aldın."

-- 2017-03-09
L.sb_sortby = "Sıralama Ölçütü:"

-- 24-07-2018
L.equip_tooltip_main = "Ekipman menüsü"
L.equip_tooltip_radar = "Radar kontrolü"
L.equip_tooltip_disguise = "Kılık değiştirme kontrolü"
L.equip_tooltip_radio = "Radyo kontrolü"
L.equip_tooltip_xfer = "Kredileri aktar"

L.confgrenade_name = "Diskombobulatör"
L.polter_name = "Poltergeist"
L.stungun_name = "UMP Prototipi"

L.knife_instant = "ANINDA ÖLDÜRME"

L.dna_hud_type = "TÜR"
L.dna_hud_body = "CESET"
L.dna_hud_item = "ÖĞE"

L.binoc_zoom_level = "SEVİYE"
L.binoc_body = "CESET ALGILANDI"

L.idle_popup_title = "Boşta"

--- 2021 -06 -07
L.sb_playervolume = "Oyuncu Sesi"

--- 2021 -09 -22
L.tip41 = "Puan tablosundaki sessize alma simgesine sağ tıklayarak bir oyuncunun mikrofon sesini ayarlayabilirsin."