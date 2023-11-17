-- Turkish language strings

local L = LANG.CreateLanguage("Turkish")

-- General text used in various places
L.traitor = "Hain"
L.detective = "Dedektif"
L.innocent = "Masum"
L.last_words = "Son Sözleri"

L.terrorists = "Teröristler"
L.spectators = "İzleyiciler"

L.nones = "Takım Yok"
L.innocents = "Masum Takımı"
L.traitors = "Hain Takımı"

-- Round status messages
L.round_minplayers = "Yeni raunda başlamak için yeterli sayıda oyuncu yok..."
L.round_voting = "Oylama devam ediyor, yeni raunt {num} saniye geciktirilecek..."
L.round_begintime = "Yeni raunt {num} saniyede başlayacak. Kendini hazırla."
L.round_selected = "Hainler seçildi."
L.round_started = "Raunt başladı!"
L.round_restart = "Raunt bir admin tarafından yeniden başlatıldı."

L.round_traitors_one = "Hey hain, yalnızsın."
L.round_traitors_more = "Hey hain, bunlar senin müttefiklerin {names}"

L.win_time = "Süre doldu. Hainler kaybetti."
L.win_traitors = "Hainler kazandı!"
L.win_innocents = "Masumlar kazandı!"
L.win_nones = "Kimse kazanamadı!"
L.win_showreport = "{num} saniye boyunca raunt raporuna bakalım."

L.limit_round = "Raunt sınırına ulaşıldı. Bir sonraki harita yakında yüklenecek."
L.limit_time = "Zaman sınırına ulaşıldı. Bir sonraki harita yakında yüklenecek."
L.limit_left = "Harita değişmeden önce {num} raunt veya {time} dakika kaldı."

-- Credit awards
L.credit_all = "Takımınıza performansınız için {num} ekipman kredisi verildi."
L.credit_kill = "Bir {role} öldürdüğünüz için {num} kredi aldınız."

-- Karma
L.karma_dmg_full = "Karman {amount}, bu yüzden bu raunt tam hasar veriyorsun!"
L.karma_dmg_other = "Karman {amount}. Sonuç olarak, verdiğiniz tüm hasar ​%{num}​ azaltılır."

-- Body identification messages
L.body_found = "{finder}, {victim} adlı kişinin cesedini buldu. {role}"
L.body_found_team = "{finder}, {victim} adlı kişinin cesedini buldu. {role} ({team})"

-- The {role} in body_found will be replaced by one of the following:
L.body_found_traitor = "Onlar bir Haindi!"
L.body_found_det = "Onlar bir Dedektifti."
L.body_found_inno = "Onlar bir Masumdu."

L.body_confirm = "{finder}, {victim} adlı kişinin ölümünü doğruladı."

L.body_call = "{player}, {victim} adlı kurbanın cesedine Dedektif çağırdı!"
L.body_call_error = "Bir Dedektif çağırmadan önce bu oyuncunun ölümünü onaylamalısın!"

L.body_burning = "Ah! Bu ceset yanıyor!"
L.body_credits = "Cesette {num} kredi buldunuz!"

-- Menus and windows
L.close = "Kapat"
L.cancel = "İptal"

-- For navigation buttons
L.next = "İleri"
L.prev = "Önceki"

-- Equipment buying menu
L.equip_title = "Ekipman"
L.equip_tabtitle = "Ekipman Sipariş Et"

L.equip_status = "Sipariş durumu"
L.equip_cost = "{num} krediniz kaldı."
L.equip_help_cost = "Satın aldığınız her ekipman parçası 1 krediye mal olur."

L.equip_help_carry = "Yalnızca yeriniz olan şeyleri satın alabilirsiniz."
L.equip_carry = "Bu ekipmanı taşıyabilirsiniz."
L.equip_carry_own = "Bu öğeyi zaten taşıyorsunuz."
L.equip_carry_slot = "{slot} yuvasında zaten bir silah taşıyorsun."
L.equip_carry_minplayers = "Sunucuda bu silahı etkinleştirmek için yeterli oyuncu yok."

L.equip_help_stock = "Belirli öğelerden her rauntta yalnızca bir tane satın alabilirsiniz."
L.equip_stock_deny = "Bu ürün artık stokta yok."
L.equip_stock_ok = "Bu ürün stokta mevcut."

L.equip_custom = "Bu sunucu tarafından eklenen özel öğe."

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
L.xfer_send = "Kredi gönder"

L.xfer_no_recip = "Alıcı geçerli değil, kredi transferi iptal edildi."
L.xfer_no_credits = "Transfer için yetersiz kredi."
L.xfer_success = "{player} adlı oyuncuya kredi transferi tamamlandı."
L.xfer_received = "{player} sana {num} kredi verdi."

-- Radio tab in equipment menu
L.radio_name = "Radyo"
L.radio_help = "Radyonuzun bu sesi çalmasını sağlamak için bir düğmeye tıklayın."
L.radio_notplaced = "Sesi çalmak için Radyoyu yerleştirmelisiniz."

-- Radio soundboard buttons
L.radio_button_scream = "Çığlık at"
L.radio_button_expl = "Patlama"
L.radio_button_pistol = "Tabanca atışları"
L.radio_button_m16 = "M16 atışları"
L.radio_button_deagle = "Deagle atışları"
L.radio_button_mac10 = "MAC10 atışları"
L.radio_button_shotgun = "Pompalı tüfek atışları"
L.radio_button_rifle = "Tüfek atışı"
L.radio_button_huge = "H.U.G.E. patlaması"
L.radio_button_c4 = "C4 bip sesi"
L.radio_button_burn = "Yanıyor"
L.radio_button_steps = "Ayak sesleri"

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
L.search_call = "Dedektifi Ara"

-- Descriptions of pieces of information found
L.search_nick = "Bu, {player} oyuncusunun cesedi."

L.search_role_traitor = "Bu kişi bir Haindi!"
L.search_role_det = "Bu kişi bir Dedektifti."
L.search_role_inno = "Bu kişi masum bir teröristti."

L.search_words = "İçinizden bir ses bu kişinin son sözlerinden bazılarının '{lastwords}' olduğunu söylüyor."
L.search_armor = "Standart olmayan vücut zırhı giyiyorlardı."
L.search_disg = "Kimliklerini gizleyebilecek bir cihaz taşıyorlardı."
L.search_radar = "Bir çeşit radar taşıyorlardı. Artık çalışmıyor."
L.search_c4 = "Cebinde bir not buldun. Tel {num} kesmenin bombayı güvenli bir şekilde etkisiz hale getireceğini belirtiyor."

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
L.search_dmg_other = "Bu teröristin ölümünün belirli bir nedenini bulamazsın."

L.search_weapon = "Görünüşe göre onları öldürmek için bir {weapon} kullanılmış."
L.search_head = "Ölümcül yara bir kafa vuruşuymuş. Çığlık atacak zaman yok."
L.search_time = "Siz aramayı yapmadan yaklaşık {time} önce öldüler."
L.search_dna = "Bir DNA Tarayıcısı ile katilin DNA'sının bir örneğini alın. DNA örneği kabaca {time} sonra bozunacak."

L.search_kills1 = "{player} oyuncusunun ölümünü doğrulayan bir leş listesi buldun."
L.search_kills2 = "Bu adlara sahip bir leş listesi buldunuz"
L.search_eyes = "Dedektiflik becerilerini kullanarak, {player} adlı oyuncuyu gördükleri son kişiyi belirledin. Katil ya da bir tesadüf"

-- Scoreboard
L.sb_playing = "Şu anda oynuyorsunuz..."
L.sb_mapchange = "{num} rauntta veya {time} içinde harita değişecektir."
L.sb_mapchange_disabled = "Oturum sınırları devre dışı."

L.sb_mia = "Eylem Eksik"
L.sb_confirmed = "Onaylanmış Ölü"

L.sb_ping = "Gecikme"
L.sb_deaths = "Ölümler"
L.sb_score = "Puan"
L.sb_karma = "Karma"

L.sb_info_help = "Bu oyuncunun cesedinde arama yapıp sonuçları buradan inceleyebilirsiniz."

L.sb_tag_friend = "ARKADAŞ"
L.sb_tag_susp = "ŞÜPHELİ"
L.sb_tag_avoid = "KAÇIN"
L.sb_tag_kill = "ÖLDÜR"
L.sb_tag_miss = "KAYIP"

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
Mermi, ateş ve patlama hasarını azaltır. Zamanla tükenir.

Birden çok kez satın alınabilir. Belirli bir zırh değerine ulaştıktan sonra, zırh güçlenir.]]

L.item_radar = "Radar"
L.item_radar_desc = [[
Yaşam belirtilerini taramanızı sağlar.

Satın alır almaz otomatik taramaları başlatır. Bu menünün Radar sekmesinde yapılandırın.]]

L.item_disg = "Kılık Değiştirici"
L.item_disg_desc = [[
Açıkken kimlik bilgilerinizi gizler. Ayrıca bir mağdur tarafından en son görülen kişi olmaktan korur.

Bu menünün Kılık Değiştirme sekmesini açın veya Numpad Enter tuşuna basın.]]

-- C4
L.c4_hint = "Devreye almak veya devre dışı bırakmak için {usekey} tuşuna basın."
L.c4_disarm_warn = "Yerleştirdiğiniz bir C4 patlayıcı etkisiz hale getirildi."
L.c4_armed = "Bombayı başarıyla devreye aldınız."
L.c4_disarmed = "Bombayı başarıyla etkisiz hale getirdiniz."
L.c4_no_room = "Bu C4'ü taşıyamazsınız."

L.c4_desc = "Güçlü zaman ayarlı patlayıcı."

L.c4_arm = "C4 kuşan"
L.c4_arm_timer = "Zamanlayıcı"
L.c4_arm_seconds = "Patlamaya saniye kaldı"
L.c4_arm_attempts = "Etkisiz hale getirme girişimlerinde, 6 telden {num} tanesi kesildiğinde anında patlamaya neden olur."

L.c4_remove_title = "Kaldırma"
L.c4_remove_pickup = "C4'ü al"
L.c4_remove_destroy1 = "C4'ü yok et"
L.c4_remove_destroy2 = "İmhayı onayla"

L.c4_disarm = "C4'ü devre dışı bırak"
L.c4_disarm_cut = "{num} telini kesmek için tıklayın"

L.c4_disarm_t = "Bombayı etkisiz hale getirmek için bir kablo kesin. Hain olduğun için her kablo güvende. Masumlar için iş o kadar kolay değil!"
L.c4_disarm_owned = "Bombayı etkisiz hale getirmek için bir kablo kesin. Bu senin bomban, bu yüzden her kablo onu etkisiz hale getirecek."
L.c4_disarm_other = "Bombayı etkisiz hale getirmek için bir kablo kesin. Yanlış yaparsan patlar!"

L.c4_status_armed = "DEVREYE ALINDI"
L.c4_status_disarmed = "DEVRE DIŞI"

-- Visualizer
L.vis_name = "Görüntüleyici"
L.vis_hint = "Açmak için {usekey} tuşuna basın (Yalnızca Dedektifler)."

L.vis_desc = [[
Olay yeri görüntüleme cihazı.

Kurbanın nasıl öldürüldüğünü göstermek için bir cesedi analiz eder, ancak sadece kurşun yaralarından ölmüşlerse.]]

-- Decoy
L.decoy_name = "Tuzak"
L.decoy_no_room = "Bu tuzağı taşıyamazsınız."
L.decoy_broken = "Tuzağınız yok edildi!"

L.decoy_short_desc = "Bu tuzak, diğer takımlar tarafından görülebilen sahte bir radar işareti gösterir"
L.decoy_pickup_wrong_team = "Farklı bir takıma ait olduğu için alamazsınız"

L.decoy_desc = [[
Diğer takımlara sahte bir radar işareti gösterir ve biri DNA'nızı tararsa DNA tarayıcısının tuzağın yerini göstermesini sağlar.]]

-- Defuser
L.defuser_name = "İmha Kiti"
L.defuser_help = "{primaryfire}, hedef C4'ü etkisiz hale getirir."

L.defuser_desc = [[
Bir C4 patlayıcısını anında etkisiz hale getirin.

Sınırsız kullanım. Bunu taşırsanız C4'ün fark edilmesi daha kolay olacaktır.]]

-- Flare gun
L.flare_name = "İşaret fişeği tabancası"

L.flare_desc = [[
Cesetleri asla bulunamayacak şekilde yakmak için kullanılabilir. Sınırlı cephane.

Bir cesedi yakmak belirgin bir ses çıkarır.]]

-- Health station
L.hstation_name = "Sağlık İstasyonu"

L.hstation_broken = "Sağlık İstasyonun yok edildi!"
L.hstation_help = "{primaryfire} Sağlık İstasyonunu yerleştirir."

L.hstation_desc = [[
Yerleştirildiğinde insanların iyileşmesini sağlar.

Yavaş şarj. Herkes kullanabilir ve zarar görebilir. Kullanıcılarının DNA örnekleri için kontrol edilebilir.]]

-- Knife
L.knife_name = "Bıçak"
L.knife_thrown = "Fırlatılan bıçak"

L.knife_desc = [[
Yaralı hedefleri anında ve sessizce öldürür, ancak yalnızca tek bir kullanımı vardır.

Alternatif ateş kullanılarak atılabilir.]]

-- Poltergeist
L.polter_desc = [[
Katilleri nesneleri şiddetle itip kakmak için üzerlerine vururlar.

Enerji patlamaları yakındaki insanlara zarar verir.]]

-- Radio
L.radio_broken = "Radyonuz yok edildi!"
L.radio_help_pri = "{primaryfire} radyoyu yerleştirir."

L.radio_desc = [[
Dikkat dağıtmak veya kandırmak için sesler çıkarır.

Radyoyu bir yere yerleştirin ve ardından bu menüdeki Radyo sekmesini kullanarak üzerindeki sesleri çalın.]]

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
Cesetleri yakınlaştırın ve uzak mesafeden teşhis edin.

Sınırsız kullanım, ancak teşhis birkaç saniye sürer.]]

-- UMP
L.ump_desc = [[
Hedeflerin yönünü şaşırtan deneysel bir SMG.

Standart SMG cephanesi kullanır.]]

-- DNA scanner
L.dna_name = "DNA tarayıcı"
L.dna_notfound = "Hedefte DNA örneği bulunamadı."
L.dna_limit = "Depolama sınırına ulaşıldı. Yenilerini eklemek için eski numuneleri kaldırın."
L.dna_decayed = "Katilin DNA örneği çürümüş."
L.dna_killer = "Cesetten katilin DNA'sından bir örnek toplandı!"
L.dna_duplicate = "Eşleşme! Tarayıcınızda bu DNA örneği zaten var."
L.dna_no_killer = "DNA alınamadı (katil bağlantısı kesildi)."
L.dna_armed = "Bu bomba aktif! Önce onu etkisiz hale getir!"
L.dna_object = "Nesneden son sahibin bir örneği toplandı."
L.dna_gone = "Bölgede DNA tespit edilmedi."

L.dna_desc = [[
Nesnelerden DNA örnekleri toplayın ve bunları DNA'nın sahibini bulmak için kullanın.

Katilin DNA'sını almak ve izini sürmek için taze cesetler üzerinde kullanın.]]

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

L.tele_help_pri = "İşaretli konuma ışınlanır"
L.tele_help_sec = "Mevcut konumu işaretler"

L.tele_desc = [[
Daha önce işaretlenmiş bir noktaya ışınlanın.

Işınlanma gürültü yapar ve kullanım sayısı sınırlıdır.]]

-- Ammo names, shown when picked up
L.ammo_pistol = "9mm cephanesi"

L.ammo_smg1 = "SMG cephanesi"
L.ammo_buckshot = "Pompalı tüfek cephanesi"
L.ammo_357 = "Tüfek cephanesi"
L.ammo_alyxgun = "Deagle cephanesi"
L.ammo_ar2altfire = "İşaret fişeği cephanesi"
L.ammo_gravity = "Poltergeist cephanesi"

-- Round status
L.round_wait = "Bekleniyor"
L.round_prep = "Hazırlanıyor"
L.round_active = "Devam ediyor"
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
L.karma_high = "Ham"
L.karma_med = "Tetik Çekmeye Hazır"
L.karma_low = "Tehlikeli"
L.karma_min = "Sorumsuz"

-- TargetID misc
L.corpse = "Ceset"
L.corpse_hint = "Arama yapmak için [{usekey}] tuşuna basın. Gizlice arama yapmak için [{walkkey}+{usekey}]."

L.target_disg = "(gizlenmiş)"
L.target_unid = "Tanımlanamayan ceset"
L.target_unknown = "Terörist"

L.target_credits = "Harcanmamış kredileri almak için arama yapın"

-- HUD buttons with hand icons that only some roles can see and use
L.tbut_single = "Tek kullanımlık"
L.tbut_reuse = "Yeniden kullanılabilir"
L.tbut_retime = "{num} saniye sonra tekrar kullanılabilir"
L.tbut_help = "Etkinleştirmek için [{usekey}] tuşuna basın"

-- Spectator muting of living/dead
L.mute_living = "Yaşayan oyuncular sessize alındı"
L.mute_specs = "İzleyiciler sessize alındı"
L.mute_all = "Tümü sessiz"
L.mute_off = "Hiçbiri sessiz değil"

-- Spectators and prop possession
L.punch_title = "GÜÇ ÖLÇER"
L.punch_bonus = "Kötü puanınız güç ölçer sınırınızı {num} düşürdü."
L.punch_malus = "İyi puanın güç ölçer sınırını {num} arttırdı!"

-- Info popups shown when the round starts
L.info_popup_innocent = [[
Sen masum bir teröristsin! Ama etrafta hainler var...
Kime güvenebilirsin ve seni kurşuna dizmek isteyen kim olabilir?

Arkanı kolla ve bu işten canlı çıkmak için yoldaşlarınla birlikte çalış!]]

L.info_popup_detective = [[
Sen bir Dedektifsin! Terörist Karargahı, hainleri bulman için sana özel kaynaklar verdi.
Masumların hayatta kalmasına yardımcı olmak için bunları kullanın, ancak dikkatli olun
hainler önce seni alaşağı etmek isteyecekler!

Ekipmanınızı almak için {menukey} tuşuna basın!]]

L.info_popup_traitor_alone = [[
Sen bir HAİNSİN! Bu rauntta hain arkadaşın yok.

Kazanmak için diğerlerini öldür!

Ekipmanınızı almak için {menukey} tuşuna basın!]]

L.info_popup_traitor = [[
Sen bir HAİNSİN! Diğerlerini öldürmek için diğer hainlerle birlikte çalışın.
Kendine iyi bak, yoksa vatan hainliğin ortaya çıkabilir...

Bunlar senin yoldaşların
{traitorlist}

Ekipmanınızı almak için {menukey} tuşuna basın!]]

-- Various other text
L.name_kick = "Rauntta bir oyuncu ismini değiştirdiği için otomatik olarak atıldı."

L.idle_popup = [[
{num} saniye boyunca boşta olduğun için İzleyici moduna aktarıldın. Bu moddayken, yeni bir raunt başladığında oyuna başlamayacaksın.

{helpkey} tuşuna basarak ve Ayarlar sekmesindeki kutunun işaretini kaldırarak istediğiniz zaman İzleyici modunu değiştirebilirsiniz. Ayrıca şu anda devre dışı bırakmayı da seçebilirsiniz.]]

L.idle_popup_close = "Hiçbir şey yapma"
L.idle_popup_off = "İzleyici modunu şimdi devre dışı bırak"

L.idle_warning = "Uyarı! Boşta gibi görünüyorsunuz ve hareket etmediğiniz sürece izleyiciye alınacaksınız!"

L.spec_mode_warning = "İzleyici modundasın ve bir raunt başladığında oyuna başlamayacaksın. Bu modu devre dışı bırakmak için F1'e basın, 'Oynanış'a gidin ve 'Yalnızca İzle modu'nun işaretini kaldırın."

-- Tips panel
L.tips_panel_title = "İpuçları"
L.tips_panel_tip = "İpucu"

-- Tip texts
L.tip1 = "Hainler, {walkkey} tuşunu basılı tutarak ve {usekey} tuşuna basarak, ölümü onaylamadan bir cesedi sessizce arayabilirler."

L.tip2 = "Bir C4 patlayıcısını daha uzun bir zamanlayıcıyla donatmak, masum biri onu etkisiz hale getirmeye çalıştığında anında patlamasına neden olan tellerin sayısını artıracaktır. Ayrıca daha yumuşak ve daha az sıklıkta bip sesi çıkaracaktır."

L.tip3 = "Dedektifler, 'gözlerine yansıyanı' bulmak için bir cesedi arayabilirler. Bu, ölü adamın gördüğü son kişi. Arkadan vurulduysa katil olmak zorunda değil."

L.tip4 = "Kimse cesedinizi bulana ve sizi arayarak teşhis edene kadar öldüğünüzü bilmeyecek."

L.tip5 = "Bir Hain bir Dedektifi öldürdüğünde, anında bir kredi ödülü alır."

L.tip6 = "Bir Hain öldüğünde, tüm Dedektifler ekipman kredisi ile ödüllendirilir."

L.tip7 = "Hainler masumları öldürmede önemli ilerleme kaydettiklerinde, ödül olarak bir ekipman kredisi alacaklar."

L.tip8 = "Hainler ve Dedektifler, diğer Hainlerin ve Dedektiflerin cesetlerinden harcanmamış ekipman kredileri toplayabilir."

L.tip9 = "Afacan Peri herhangi bir fizik nesnesini ölümcül bir mermiye dönüştürebilir. Her yumruğa, yakındaki herkese zarar veren bir enerji patlaması eşlik eder."

L.tip10 = "Hain veya Dedektifseniz, sağ üstteki kırmızı mesajlara dikkat edin. Bunlar sizin için önemli olacak."

L.tip11 = "Hain veya Dedektif olarak, siz ve yoldaşlarınız iyi performans gösterirseniz ekstra ekipman kredisi ile ödüllendirileceğinizi unutmayın. Harcamayı unutmayın!"

L.tip12 = "Dedektiflerin DNA Tarayıcısı, silahlardan ve eşyalardan DNA örnekleri toplamak ve daha sonra bunları kullanan oyuncunun yerini bulmak için tarama yapmak için kullanılabilir. Bir cesetten veya etkisiz hale getirilmiş bir C4'ten numune alabildiğinizde kullanışlıdır!"

L.tip13 = "Öldürdüğünüz birine yakın olduğunuzda, DNA'nızın bir kısmı cesedin üzerinde kalır. Bu DNA, mevcut konumunuzu bulmak için bir Dedektifin DNA Tarayıcısı ile kullanılabilir. Birini bıçakladıktan sonra cesedi saklasan iyi olur!"

L.tip14 = "Öldürdüğünüz birinden ne kadar uzaktaysanız, vücudundaki DNA örneğiniz o kadar hızlı bozulur."

L.tip15 = "Hain misin ve keskin nişancılık mı yapıyorsun? Kılık Değiştiriciyi denemeyi düşün. Bir atışı kaçırırsan, güvenli bir yere kaç, Kılık Değiştiriciyi devre dışı bırak ve hiç kimse onlara ateş edenin sen olduğunu bilmeyecek."

L.tip16 = "Hain olarak Işınlayıcı, kovalandığında kaçmana yardımcı olabilir ve büyük bir harita üzerinde hızlı bir şekilde seyahat etmeni sağlar. Her zaman işaretli güvenli bir pozisyonunuz olduğundan emin olun."

L.tip17 = "Masumların hepsi gruplanmış ve öldürmesi zor mu? C4 seslerini çalmak için Radyoyu veya bazılarını uzaklaştırmak için ateş etmeyi düşünün."

L.tip18 = "Radyoyu Hainken, radyo yerleştirildikten sonra Ekipman Menünüzden sesleri çalabilirsiniz. İstediğiniz sırayla birden fazla düğmeye tıklayarak birden fazla sesi sıraya koyun."

L.tip19 = "Dedektifken, kalan kredileriniz varsa, güvenilir bir Masuma İmha Kiti verebilirsiniz. O zaman zamanınızı ciddi araştırma çalışmaları yaparak geçirebilir ve riskli bomba imha işini onlara bırakabilirsiniz."

L.tip20 = "Dedektiflerin Dürbünü, cesetlerin uzun menzilli aranmasına ve tanımlanmasına izin verir. Hainler bir cesedi yem olarak kullanmayı umuyorsa kötü haber. Elbette, Dürbünü kullanırken bir Dedektif silahsızdır ve dikkati dağılır..."

L.tip21 = "Dedektiflerin Sağlık İstasyonu, yaralı oyuncuların iyileşmesini sağlar. Tabii o yaralılar da Hain olabilir..."

L.tip22 = "Sağlık İstasyonu, onu kullanan herkesin DNA örneğini kaydeder. Dedektifler bunu DNA Tarayıcısı ile kimin iyileştiğini bulmak için kullanabilirler."

L.tip23 = "Silahlar ve C4'ten farklı olarak, Hainler için Radyo ekipmanı, onu yerleştiren kişinin DNA örneğini içermez. Dedektiflerin onu bulması ve kimliğini ifşa etmesi konusunda endişelenme."

L.tip24 = "Kısa bir öğreticiyi görüntülemek veya TTT'ye özgü bazı ayarları değiştirmek için {helpkey} tuşuna basın. Örneğin, bu ipuçlarını kalıcı olarak devre dışı bırakabilirsiniz."

L.tip25 = "Dedektif bir cesedi aradığında, sonuç ölü kişinin adına tıklayarak puan panosu aracılığıyla tüm oyuncuların kullanımına açıktır."

L.tip26 = "Skor tablosunda, birinin adının yanındaki büyüteç simgesi, o kişi hakkında arama bilgilerine sahip olduğunuzu gösterir. Simge parlaksa, veriler bir Dedektiften gelir ve ek bilgiler içerebilir."

L.tip27 = "Dedektif olarak, takma addan sonra büyüteç takılan cesetler bir Dedektif tarafından arandı ve sonuçları skor tablosu aracılığıyla tüm oyunculara açıktır."

L.tip28 = "İzleyiciler, diğer izleyicileri veya yaşayan oyuncuları susturmak için {mutekey} tuşuna basabilir."

L.tip29 = "Sunucu ek diller yüklediyse, Ayarlar menüsünden istediğiniz zaman farklı bir dile geçebilirsiniz."

L.tip30 = "Hızlı sohbet veya 'radyo' komutları {zoomkey} tuşuna basılarak kullanılabilir."

L.tip31 = "İzleyiciyken, fare imlecinin kilidini açmak için {duckkey} tuşuna bas ve bu ipuçları panelindeki düğmelere tıkla. Fare görünümüne geri dönmek için {duckkey} tuşuna tekrar basın."

L.tip32 = "Levyenin ikincil ateşi diğer oyuncuları itecektir."

L.tip33 = "Nişangahı kullanarak ateş etmek, isabetini biraz artıracak ve geri tepmeyi azaltacaktır. Çömelmek işe yaramaz."

L.tip34 = "Duman bombaları, özellikle kalabalık odalarda kafa karışıklığı yaratmak için iç mekanlarda etkilidir."

L.tip35 = "Hain olarak, cesetleri taşıyabileceğinizi ve onları masumların ve Dedektiflerinin meraklı gözlerinden saklayabileceğinizi unutmayın."

L.tip36 = "{helpkey} altında bulunan öğretici, oyunun en önemli ince ayrıntılarına genel bir bakış içerir."

L.tip37 = "Skor tablosunda, yaşayan bir oyuncunun adına tıklayıp 'şüpheli' veya 'arkadaş' gibi bir etiket seçebilirsiniz. Bu etiket, nişangahınızın altındaysa görünecektir."

L.tip38 = "Yerleştirilebilir ekipman öğelerinin çoğu (C4, Radyo gibi) ikincil ateş kullanılarak duvarlara yapıştırılabilir."

L.tip39 = "Etkisiz hale getirilirken bir hata nedeniyle patlayan C4, zamanlayıcısında sıfıra ulaşan C4'ten daha küçük bir patlamaya sahiptir."

L.tip40 = "Raunt zamanlayıcısının üzerinde 'HIZLI MOD' yazıyorsa, raunt ilk başta sadece birkaç dakika uzunluğunda olacaktır, ancak her ölümle birlikte mevcut süre artar (TF2'deki bir noktayı yakalamak gibi). Bu mod, hainlere işlerini devam ettirmeleri için baskı yapar."

-- Round report
L.report_title = "Raunt Raporu"

-- Tabs
L.report_tab_hilite = "Önemli Noktalar"
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

-- Columns
L.col_time = "Zaman"
L.col_event = "Olay"
L.col_player = "Oyuncu"
L.col_roles = "Rol(ler)"
L.col_teams = "Takım(lar)"
L.col_kills1 = "Öldürmeler"
L.col_kills2 = "Takım öldürmeleri"
L.col_points = "Puanlar"
L.col_team = "Takım bonusu"
L.col_total = "Toplam puan"

-- Awards/highlights
L.aw_sui1_title = "İntihar Tarikatı Lideri"
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
L.aw_fst2_text = "bir hain dostunu vurarak ilk cinayeti işledi. İyi iş."

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
L.aw_nkt3_text = "bugün üç masum terörizm hayatına son verdi."

L.aw_nkt4_title = "Daha Fazla Koyun Benzeri Kurt Arasında Kurt"
L.aw_nkt4_text = "Masum teröristleri akşam yemeğinde yer. {num} yemekten oluşan bir akşam yemeği."

L.aw_nkt5_title = "Terörle Mücadele Operatörü"
L.aw_nkt5_text = "öldürme başına ödeme alır. Artık başka bir lüks yat satın alabilirim."

L.aw_nki1_title = "Buna İhanet Et"
L.aw_nki1_text = "bir hain buldu. Bir haini vurdu. Kolaydı."

L.aw_nki2_title = "Adalet Ekibine Müracaat Edildi"
L.aw_nki2_text = "iki haine büyük öteye kadar eşlik etti."

L.aw_nki3_title = "Hainler Hain Koyun Düşler mi"
L.aw_nki3_text = "üç haine tatlı rüyalar gördür."

L.aw_nki4_title = "İçişleri Çalışanı"
L.aw_nki4_text = "öldürme başına ödeme alır. Artık beşinci yüzme havuzunu sipariş edebilir."

L.aw_fal1_title = "Hayır Bay Bond, Düşmenizi Bekliyorum"
L.aw_fal1_text = "birini büyük bir yükseklikten itti."

L.aw_fal2_title = "Döşenmiş"
L.aw_fal2_text = "kayda değer bir yükseklikten düştükten sonra bedenlerinin yere çarpmasına izin verin."

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
L.aw_mac2_text = "iki MAC10 kullanabilseler ne olacağını merak ediyor. {num} çarpı iki"

L.aw_sip1_title = "Sessiz Ol"
L.aw_sip1_text = "{num} kişiyi susturulmuş tabancayla sustur."

L.aw_sip2_title = "Susturulmuş Suikastçı"
L.aw_sip2_text = "kendini ölürken duymayan {num} kişiyi öldürdü."

L.aw_knf1_title = "Seni Bilen Bıçak"
L.aw_knf1_text = "internet üzerinden birini yüzünden bıçakladı."

L.aw_knf2_title = "Bunu Nereden Aldın"
L.aw_knf2_text = "bir Hain değildi, ama yine de bıçakla birini öldürdü."

L.aw_knf3_title = "Böyle Bir Bıçak Adam"
L.aw_knf3_text = "etrafta {num} bıçak buldu ve bunlardan faydalandı."

L.aw_knf4_title = "Dünyanın En Bıçak Adamı"
L.aw_knf4_text = "{num} kişiyi bıçakla öldürdü. Nasıl olduğunu sorma."

L.aw_flg1_title = "Kurtarmaya"
L.aw_flg1_text = "işaret fişeklerini {num} ölüm sinyali vermek için kullandı."

L.aw_flg2_title = "İşaret Fişeği Yangını Gösterir"
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
L.aw_tkl5_text = "dürüstçe deli bir adamı canlandırıyordu. Bu yüzden takımlarının çoğunu öldürdüler."

L.aw_tkl6_title = "Aptal"
L.aw_tkl6_text = "hangi tarafta olduklarını anlayamadılar ve yoldaşlarının yarısından fazlasını öldürdüler."

L.aw_tkl7_title = "Cahil"
L.aw_tkl7_text = "takım arkadaşlarının dörtte birinden fazlasını öldürerek bölgelerini gerçekten iyi korudu."

L.aw_brn1_title = "Eskiden Büyükannemin Yaptığı Gibi"
L.aw_brn1_text = "birkaç kişiyi güzelce kızarttı."

L.aw_brn2_title = "Kundakçı"
L.aw_brn2_text = "kurbanlarından birini yaktıktan sonra yüksek sesle kıkırdadığı duyuldu."

L.aw_brn3_title = "Kundakçının Ateşi Söner"
L.aw_brn3_text = "hepsini yaktı, ama şimdi hiç yakıcı el bombası kalmadı! Nasıl başa çıkacaklar!"

L.aw_fnd1_title = "Adli tabip"
L.aw_fnd1_text = "etrafta {num} ceset bulundu."

L.aw_fnd2_title = "Hepsini Yakalamalıyım"
L.aw_fnd2_text = "koleksiyonları için {num} ceset bulundu."

L.aw_fnd3_title = "Ölüm Kokusu"
L.aw_fnd3_text = "bu turda {num} kez rastgele cesetler üzerinde tökezler."

L.aw_crd1_title = "Geri Dönüştürücü"
L.aw_crd1_text = "cesetlerden {num} kredi toplandı."

L.aw_tod1_title = "Kundakçının Zaferi"
L.aw_tod1_text = "takımları raundu kazanmadan sadece saniyeler önce öldü."

L.aw_tod2_title = "Bu Oyundan Nefret Ediyorum"
L.aw_tod2_text = "raundun başlamasından hemen sonra öldü."

-- New and modified pieces of text are placed below this point, marked with the
-- version in which they were added, to make updating translations easier.

-- v24
L.drop_no_ammo = "Silahının şarjöründe cephane kutusu olarak düşecek yeterli cephane yok."

-- 2015-05-25
L.hat_retrieve = "Bir Dedektif'in şapkasını aldın."

-- 2017-09-03
L.sb_sortby = "Sıralama Ölçütü"

-- 2018-07-24
L.equip_tooltip_main = "Ekipman menüsü"
L.equip_tooltip_radar = "Radar kontrolü"
L.equip_tooltip_disguise = "Kılık değiştirme kontrolü"
L.equip_tooltip_radio = "Radyo kontrolü"
L.equip_tooltip_xfer = "Kredileri aktar"
L.equip_tooltip_reroll = "Ekipmanı yeniden dağıt"

L.confgrenade_name = "Kafa Karıştırıcı"
L.polter_name = "Afacan Peri"
L.stungun_name = "UMP Prototipi"

L.knife_instant = "ANINDA ÖLDÜRME"

L.binoc_zoom_level = "Yakınlaştırma Seviyesi"
L.binoc_body = "CESET ALGILANDI"

L.idle_popup_title = "Boşta"

-- 2019-01-31
L.create_own_shop = "Kendi mağazanı oluştur"
L.shop_link = "Şununla bağlantı kur"
L.shop_disabled = "Mağazayı devre dışı bırak"
L.shop_default = "Varsayılan mağazayı kullan"

-- 2019-05-05
L.reroll_name = "Yeniden dağıt"
L.reroll_menutitle = "Ekipmanı yeniden dağıt"
L.reroll_no_credits = "Yeniden dağıtmak için {amount} krediye ihtiyacınız var!"
L.reroll_button = "Yeniden Dağıt"
L.reroll_help = "Mağazanızda yeni bir rastgele ekipman seti almak için {amount} kredi kullanın!"

-- 2019-05-06
L.equip_not_alive = "Sağdan bir rol seçerek mevcut tüm öğeleri görüntüleyebilirsiniz. Favorilerinizi işaretlemeyi unutmayın!"

-- 2019-06-27
L.shop_editor_title = "Mağaza Düzenleme"
L.shop_edit_items_weapong = "Silahları Düzenle"
L.shop_edit = "Mağazaları Düzenle"
L.shop_settings = "Ayarlar"
L.shop_select_role = "Rol Seç"
L.shop_edit_items = "Öğeleri Düzenle"
L.shop_edit_shop = "Mağazayı Düzenle"
L.shop_create_shop = "Özel Mağaza Oluştur"
L.shop_selected = "Seçili {role}"
L.shop_settings_desc = "Rastgele Mağaza Konsol Değişkeni uyarlamak için değerleri değiştirin. Değişikliklerinizi kaydetmeyi unutmayın!"

L.bindings_new = "{name} {key} için atanan yeni tuş"

L.hud_default_failed = "{hudname} arayüzü varsayılan olarak ayarlanamadı. Bunu yapma izniniz yok veya bu arayüz mevcut değil."
L.hud_forced_failed = "{hudname} arayüzü zorlanamadı. Bunu yapma izniniz yok veya bu arayüz mevcut değil."
L.hud_restricted_failed = "{hudname} arayüzü kısıtlanamadı. Bunu yapmak için iznin yok."

L.shop_role_select = "Bir rol seçin"
L.shop_role_selected = "{role} adlı rolün mağazası seçildi!"
L.shop_search = "Ara"

-- 2019-10-19
L.drop_ammo_prevented = "Bir şey cephanenizi düşürmenizi engelliyor."

-- 2019-10-28
L.target_c4 = "C4 menüsünü açmak için [{usekey}] tuşuna basın"
L.target_c4_armed = "C4'ü devre dışı bırakmak için [{usekey}] tuşuna basın"
L.target_c4_armed_defuser = "İmha kitini kullanmak için [{usekey}] tuşuna basın"
L.target_c4_not_disarmable = "Yaşayan bir takım arkadaşının C4'ünü devre dışı bırakamazsın"
L.c4_short_desc = "Çok patlayıcı bir şey"

L.target_pickup = "Almak için [{usekey}] tuşuna basın"
L.target_slot_info = "{slot} yuvası"
L.target_pickup_weapon = "Silahı almak için [{usekey}] tuşuna basın"
L.target_switch_weapon = "Mevcut silahınla değiştirmek için [{usekey}] tuşuna basın"
L.target_pickup_weapon_hidden = "Gizli alım için [{walkkey} + {usekey}] tuşuna basın"
L.target_switch_weapon_hidden = "Gizli anahtar için [{walkkey} + {usekey}] tuşuna basın"
L.target_switch_weapon_nospace = "Bu silah için kullanılabilir envanter yuvası yok"
L.target_switch_drop_weapon_info = "{name} {slot} yuvasından bırakılıyor"
L.target_switch_drop_weapon_info_noslot = "{slot} yuvasında düşürülebilir silah yok"

L.corpse_searched_by_detective = "Bu ceset bir dedektif tarafından arandı"
L.corpse_too_far_away = "Ceset çok uzakta."

L.radio_pickup_wrong_team = "Radyoyu başka bir takımdan alamazsın."
L.radio_short_desc = "Silah sesleri benim için müziktir"

L.hstation_subtitle = "Sağlık almak için [{usekey}] tuşuna basın."
L.hstation_charge = "Sağlık istasyonunun kalan şarjı {charge}"
L.hstation_empty = "Bu sağlık istasyonunda daha fazla şarj kalmadı"
L.hstation_maxhealth = "Sağlığınız tam"
L.hstation_short_desc = "Sağlık istasyonu zaman içinde yavaş yavaş şarj olur"

-- 2019-11-03
L.vis_short_desc = "Kurban ateşli silahla yaralanarak öldüyse olay yerini gösterir"
L.corpse_binoculars = "Cesedi dürbünle aramak için [{key}] tuşuna basın."
L.binoc_progress = "Aranıyor: %{progress}"

L.pickup_no_room = "Bu silah türü için envanterinizde yer yok."
L.pickup_fail = "Bu silahı alamazsın."
L.pickup_pending = "Zaten bir silah aldın, alana kadar bekle."

-- 2020-01-07
L.tbut_help_admin = "Hain düğmesi ayarlarını düzenle"
L.tbut_role_toggle = "[{walkkey} + {usekey}] düğmesi {role} için"
L.tbut_role_config = "Rol {current}"
L.tbut_team_toggle = "{team} takımı için bu düğmeyi değiştirmek için [SHIFT + {walkkey} + {usekey}]"
L.tbut_team_config = "Takım {current}"
L.tbut_current_config = "Geçerli yapılandırma"
L.tbut_intended_config = "Harita oluşturucu tarafından tasarlanan yapılandırma"
L.tbut_admin_mode_only = "Yönetici olduğunuz ve '{cv}' öğesi '1' olarak ayarlandığı için bu düğmeyi görüyorsunuz."
L.tbut_allow = "İzin ver"
L.tbut_prohib = "Yasakla"
L.tbut_default = "Varsayılan"

-- 2020-02-09
L.name_door = "Kapı"
L.door_open = "Kapıyı açmak için [{usekey}] tuşuna basın."
L.door_close = "Kapıyı kapatmak için [{usekey}] tuşuna basın."
L.door_locked = "Bu kapı kilitli."

-- 2020-02-11
L.automoved_to_spec = "(OTOMATİK MESAJ) Boşta olduğum için İzleyici takımına alındım."
L.mute_team = "{team} sessize alındı."

-- 2020-02-16
L.door_auto_closes = "Bu kapı otomatik olarak kapanır."
L.door_open_touch = "Açmak için kapıya doğru yürü."
L.door_open_touch_and_use = "Kapıya doğru yürü veya açmak için [{usekey}] tuşuna bas."
L.hud_health = "Sağlık"

-- 2020-03-09
L.help_title = "Yardım ve Ayarlar"

L.menu_changelog_title = "Değişiklik günlüğü"
L.menu_guide_title = "TTT2 Kılavuzu"
L.menu_bindings_title = "Tuş Atamaları"
L.menu_language_title = "Dil"
L.menu_appearance_title = "Görünüm"
L.menu_gameplay_title = "Oynanış"
L.menu_addons_title = "Eklentiler"
L.menu_legacy_title = "Eski Eklentiler"
L.menu_administration_title = "Yönetim"
L.menu_equipment_title = "Ekipmanı Düzenle"
L.menu_shops_title = "Mağazaları Düzenle"

L.menu_changelog_description = "Son sürümlerdeki değişikliklerin ve düzeltmelerin listesi."
L.menu_guide_description = "TTT2'ye başlamanıza yardımcı olur ve oyun, roller ve diğer şeyler hakkında bazı şeyleri açıklar."
L.menu_bindings_description = "TTT2'nin ve eklentilerinin belirli özelliklerini kendi beğeninize göre ayarlayın."
L.menu_language_description = "Oyun modunun dilini seçin."
L.menu_appearance_description = "Kullanıcı arayüzünün görünümünü ve performansını değiştirin."
L.menu_gameplay_description = "Rollerden kaçının ve bazı özellikleri düzenleyin."
L.menu_addons_description = "Yerel eklentileri istediğiniz gibi yapılandırın."
L.menu_legacy_description = "Orijinal TTT'den dönüştürülen sekmelerin yeni sisteme taşınması gereken bir panel."
L.menu_administration_description = "Arayüzler, mağazalar vb. için genel ayarlar"
L.menu_equipment_description = "Kredileri, sınırlamaları, kullanılabilirliği ve diğer şeyleri ayarlayın."
L.menu_shops_description = "Mağazaları istediğiniz roller için ekleyin ve hangi ekipmanlara sahip olduklarını yapılandırın."

L.submenu_guide_gameplay_title = "Oynanış"
L.submenu_guide_roles_title = "Roller"
L.submenu_guide_equipment_title = "Ekipman"

L.submenu_bindings_bindings_title = "Atamalar"

L.submenu_language_language_title = "Dil"

L.submenu_appearance_general_title = "Genel"
L.submenu_appearance_hudswitcher_title = "Arayüz Değiştirici"
L.submenu_appearance_vskin_title = "Valve Arayüzü"
L.submenu_appearance_targetid_title = "Hedef Kimliği"
L.submenu_appearance_shop_title = "Mağaza Ayarları"
L.submenu_appearance_crosshair_title = "Nişangah"
L.submenu_appearance_dmgindicator_title = "Hasar Göstergesi"
L.submenu_appearance_performance_title = "Performans"
L.submenu_appearance_interface_title = "Arayüz"
L.submenu_appearance_miscellaneous_title = "Çeşitli"

L.submenu_gameplay_general_title = "Genel"
L.submenu_gameplay_avoidroles_title = "Rol Seçiminden Kaçın"

L.submenu_administration_hud_title = "Arayüz Ayarları"
L.submenu_administration_randomshop_title = "Rasgele Mağaza"

L.help_color_desc = "Bu ayar etkinleştirilirse, hedef kimliği dış çizgisi ve nişangah için kullanılacak genel bir renk seçebilirsiniz."
L.help_scale_factor = "Bu ölçek faktörü tüm arayüz öğelerini (Arayüz, Valve Grafiksel Kullanıcı Arayüzü ve Hedef Kimliği) etkiler. Ekran çözünürlüğü değiştirilirse otomatik olarak güncellenir. Bu değerin değiştirilmesi arayüzü sıfırlayacaktır!"
L.help_hud_game_reload = "Arayüz şu anda kullanılamıyor. Sunucuya yeniden bağlanın veya oyunu yeniden başlatın."
L.help_hud_special_settings = "Bunlar bu arayüzün özel ayarlarıdır."
L.help_vskin_info = "Valve Arayüzü (Valve Grafiksel Kullanıcı Arayüz görünümü), mevcut olan tüm menü öğelerine uygulanan görünümdür. Basit bir Lua komut dosyası ile kolayca oluşturulabilirler ve renkleri ve bazı boyut parametrelerini değiştirebilirler."
L.help_targetid_info = "Hedef Kimliği, nişangahınızı bir varlığa yönlendirirken oluşturulan bilgilerdir. Rengi 'Genel' sekmesinde yapılandırılabilir."
L.help_hud_default_desc = "Tüm oyuncular için varsayılan arayüz değerini ayarlar. Henüz bir arayüz seçmemiş olan oyuncular, varsayılan olarak bu arayüzü alacaklardır. Bunu değiştirmek, arayüzlerini zaten seçmiş olan oyuncuların arayüzlerini değiştirmez."
L.help_hud_forced_desc = "Tüm oyuncular için bir arayüz zorlar. Bu, arayüz seçim özelliğini herkes için devre dışı bırakır."
L.help_hud_enabled_desc = "Bu arayüzlerin seçimini kısıtlamak için etkinleştir veya devre dışı bırak."
L.help_damage_indicator_desc = "Hasar göstergesi, oyuncu hasar gördüğünde gösterilen bir göstergedir. Yeni bir tema eklemek için 'materialsvguitttdamageindicatorthemes' içine bir png yerleştirin."
L.help_shop_key_desc = "Bir raundun sonunda hazırlanırken skor menüsü yerine mağaza tuşuna basarak mağazayı açın"

L.label_menu_menu = "MENÜ"
L.label_menu_admin_spacer = "Admin Alanı (normal kullanıcılara gösterilmez)"
L.label_language_set = "Dil seç"
L.label_global_color_enable = "Genel rengi etkinleştir"
L.label_global_color = "Genel renk"
L.label_global_scale_factor = "Genel ölçek faktörü"
L.label_hud_select = "Arayüz Seç"
L.label_vskin_select = "Valve Arayüzü seçin"
L.label_blur_enable = "Valve Arayüz arka plan bulanıklığını etkinleştir"
L.label_color_enable = "Valve Arayüz arka plan rengini etkinleştir"
L.label_minimal_targetid = "Nişangah altında minimalist Hedef Kimliği (Karma metni, ipuçları vb.)"
L.label_shop_always_show = "Her zaman mağazayı göster"
L.label_shop_double_click_buy = "Mağazada üzerine çift tıklayarak bir ürün satın almayı etkinleştir"
L.label_shop_num_col = "Sütun sayısı"
L.label_shop_num_row = "Satır sayısı"
L.label_shop_item_size = "Simge boyutu"
L.label_shop_show_slot = "Yuva işaretini göster"
L.label_shop_show_custom = "Özel öğe işaretini göster"
L.label_shop_show_fav = "Favori öğe işaretini göster"
L.label_crosshair_enable = "Nişangahı etkinleştir"
L.label_crosshair_gap_enable = "Özel nişangah boşluğunu etkinleştir"
L.label_crosshair_gap = "Özel nişangah aralığı"
L.label_crosshair_opacity = "Nişangah opaklığı"
L.label_crosshair_ironsight_opacity = "Demir nişangah opaklığı"
L.label_crosshair_size = "Nişangah boyutu"
L.label_crosshair_thickness = "Nişangah kalınlığı"
L.label_crosshair_thickness_outline = "Nişangah dış çizgi kalınlığı"
L.label_crosshair_static_enable = "Sabit nişangahı etkinleştir"
L.label_crosshair_dot_enable = "Nişangah noktasını etkinleştir"
L.label_crosshair_lines_enable = "Nişangah çizgilerini etkinleştir"
L.label_crosshair_scale_enable = "Silaha bağlı silah ölçeğini etkinleştir"
L.label_crosshair_ironsight_low_enabled = "Demir nişangah kullanırken silahı indirin"
L.label_damage_indicator_enable = "Hasar göstergesini etkinleştir"
L.label_damage_indicator_mode = "Hasar göstergesi temasını seçin"
L.label_damage_indicator_duration = "Vurulduktan sonra solma süresi (saniye olarak)"
L.label_damage_indicator_maxdamage = "Maksimum opaklık için gereken hasar"
L.label_damage_indicator_maxalpha = "Maksimum opaklık"
L.label_performance_halo_enable = "Bazı varlıklara bakarken etrafına bir dış çizgi çizin"
L.label_performance_spec_outline_enable = "Kontrol edilen nesnelerin dış çizgilerini etkinleştir"
L.label_performance_ohicon_enable = "Oyuncuların başındaki rol simgelerini etkinleştir"
L.label_interface_tips_enable = "İzlerken ekranın alt kısmında oyun ipuçlarını göster"
L.label_interface_popup = "Raunt başlangıç bilgisini gösteren açılan pencerenin süresi"
L.label_interface_fastsw_menu = "Hızlı silah değişme ile menüyü etkinleştir"
L.label_inferface_wswitch_hide_enable = "Silah değişme menüsünün otomatik olarak kapanmasını etkinleştir"
L.label_inferface_scues_enable = "Bir raunt başladığında veya bittiğinde ses işaretini çal"
L.label_gameplay_specmode = "Yalnızca İzle modu (her zaman izleyici olarak kal)"
L.label_gameplay_fastsw = "Hızlı silah değişme"
L.label_gameplay_hold_aim = "Nişan almak için tutmayı etkinleştir"
L.label_gameplay_mute = "Öldüğünde canlı oyuncuları sessize al"
L.label_hud_default = "Varsayılan Arayüz"
L.label_hud_force = "Zorunlu Arayüz"

L.label_bind_weaponswitch = "Silahı Al"
L.label_bind_voice = "Genel Sesli Sohbet"
L.label_bind_voice_team = "Takım Sesli Sohbeti"

L.label_hud_basecolor = "Temel Renk"

L.label_menu_not_populated = "Bu alt menü herhangi bir içerik içermiyor."

L.header_bindings_ttt2 = "TTT2 Atamaları"
L.header_bindings_other = "Diğer Atamalar"
L.header_language = "Dil Ayarları"
L.header_global_color = "Genel Rengi Seç"
L.header_hud_select = "Bir arayüz seçin"
L.header_hud_customize = "Arayüzü Özelleştir"
L.header_vskin_select = "Valve Arayüzü Seç ve Özelleştir"
L.header_targetid = "Hedef Kimliği Ayarları"
L.header_shop_settings = "Ekipman Mağazası Ayarları"
L.header_shop_layout = "Öğe Listesi Düzeni"
L.header_shop_marker = "Öğe İşaretleyici Ayarları"
L.header_crosshair_settings = "Nişangah Ayarları"
L.header_damage_indicator = "Hasar Göstergesi Ayarları"
L.header_performance_settings = "Performans Ayarları"
L.header_interface_settings = "Arayüz Ayarları"
L.header_gameplay_settings = "Oynanış Ayarları"
L.header_roleselection = "Kaçınılan Rolleri Seç"
L.header_hud_administration = "Varsayılan ve Zorunlu Arayüzleri Seç"
L.header_hud_enabled = "Arayüzleri etkinleştir veya devre dışı bırak"

L.button_menu_back = "Geri"
L.button_none = "Yok"
L.button_press_key = "Bir tuşa basın"
L.button_save = "Kaydet"
L.button_reset = "Sıfırla"
L.button_close = "Kapat"
L.button_hud_editor = "Arayüz Düzenleyici"

-- 2020-04-20
L.item_speedrun = "Hız"
L.item_speedrun_desc = [[Sizi % 50 daha hızlı yapar!]]
L.item_no_explosion_damage = "Patlama Hasarı Yok"
L.item_no_explosion_damage_desc = [[Patlama hasarına karşı bağışıklık kazandırır.]]
L.item_no_fall_damage = "Düşme Hasarı Yok"
L.item_no_fall_damage_desc = [[Düşme hasarına karşı bağışıklık kazandırır.]]
L.item_no_fire_damage = "Yangın Hasarı Yok"
L.item_no_fire_damage_desc = [[Yangın hasarına karşı bağışıklık kazandırır.]]
L.item_no_hazard_damage = "Tehlike Hasarı Yok"
L.item_no_hazard_damage_desc = [[Zehir, radyasyon ve asit gibi tehlike hasarlarına karşı bağışıklık kazandırır.]]
L.item_no_energy_damage = "Enerji Hasarı Yok"
L.item_no_energy_damage_desc = [[Lazer, plazma ve yıldırım gibi enerji hasarlarına karşı bağışıklık kazandırır.]]
L.item_no_prop_damage = "Nesne Hasarı Yok"
L.item_no_prop_damage_desc = [[Nesne hasarına karşı bağışıklık kazandırır.]]
L.item_no_drown_damage = "Boğulma Hasarı Yok"
L.item_no_drown_damage_desc = [[Boğulma hasarına karşı bağışıklık kazandırır.]]

-- 2020-04-21
L.dna_tid_possible = "Tarama yapılabilir."
L.dna_tid_impossible = "Tarama yapılamaz."
L.dna_screen_ready = "DNA yok"
L.dna_screen_match = "Eşleşme"

-- 2020-04-30
L.message_revival_canceled = "Canlandırma iptal edildi."
L.message_revival_failed = "Canlandırma başarısız oldu."
L.message_revival_failed_missing_body = "Cesediniz artık mevcut olmadığı için diriltilemediniz."
L.hud_revival_title = "Dirilişe kalan süre"
L.hud_revival_time = "{time}sn"

-- 2020-05-03
L.door_destructible = "Bu kapı yok edilebilir ({health}SP)."

-- 2020-05-28
L.confirm_detective_only = "Sadece dedektifler cesetleri doğrulayabilir."
L.inspect_detective_only = "Sadece dedektifler cesetleri arayabilir."
L.corpse_hint_no_inspect = "Sadece dedektifler bu cesedi arayabilir."
L.corpse_hint_inspect_only = "Aramak için [{usekey}] tuşuna basın. Cesedi sadece dedektifler doğrulayabilir."
L.corpse_hint_inspect_only_credits = "Kredi almak için [{usekey}] tuşuna basın. Bu cesedi sadece dedektifler arayabilir."

-- 2020-06-04
L.label_bind_disguiser = "Kılık Değiştiriciyi aç/kapat"

-- 2020-06-24
L.dna_help_primary = "DNA örneği al"
L.dna_help_secondary = "DNA yuvasını değiştirin"
L.dna_help_reload = "Numuneyi sil"

L.binoc_help_pri = "Bir ceset ara."
L.binoc_help_sec = "Yakınlaştırma seviyesini değiştirin."

L.vis_help_pri = "Etkinleştirilmiş cihazı bırakın."

L.decoy_help_pri = "Tuzağı yerleştirin."

-- 2020-08-07
L.pickup_error_spec = "Bunu izleyici olarak alamazsın."
L.pickup_error_owns = "Bu silah zaten sende olduğu için bunu alamazsın."
L.pickup_error_noslot = "Boş alanın olmadığı için bunu alamazsın."

-- 2020-11-02
L.lang_server_default = "Sunucu Varsayılanı"
L.help_lang_info = [[
Bu çeviri %{coverage} oranında tamamlandı ve İngilizce dili varsayılan referans olarak alındı.

Bu çevirilerin topluluk tarafından yapıldığını unutmayın. Bir şey eksik veya yanlışsa katkıda bulunmaktan çekinmeyin.]]

-- 2021-04-13
L.title_score_info = "Raunt Sonu Bilgisi"
L.title_score_events = "Olay Zaman Çizelgesi"

L.label_bind_clscore = "Açık raunt raporu"
L.title_player_score = "{player} puanı"

L.label_show_events = "Şuradaki olayları göster"
L.button_show_events_you = "Siz"
L.button_show_events_global = "Genel"
L.label_show_roles = "Rol dağılımını göster"
L.button_show_roles_begin = "Raunt Başlangıcı"
L.button_show_roles_end = "Raunt Sonu"

L.hilite_win_traitors = "HAİN TAKIMI KAZANDI"
L.hilite_win_innocents = "MASUM TAKIMI KAZANDI"
L.hilite_win_tie = "BERABERE"
L.hilite_win_time = "SÜRE DOLDU"

L.tooltip_karma_gained = "Bu raunt için Karma değişiklikleri"
L.tooltip_score_gained = "Bu raunt için puan değişiklikleri"
L.tooltip_roles_time = "Bu raunt için rol değişiklikleri"

L.tooltip_finish_score_alive_teammates = "Canlı takım arkadaşları {score}"
L.tooltip_finish_score_alive_all = "Canlı oyuncular {score}"
L.tooltip_finish_score_timelimit = "Süre doldu {score}"
L.tooltip_finish_score_dead_enemies = "Ölü düşmanlar {score}"
L.tooltip_kill_score = "Öldürme {score}"
L.tooltip_bodyfound_score = "Ceset bulundu {score}"

L.finish_score_alive_teammates = "Canlı takım arkadaşları"
L.finish_score_alive_all = "Canlı oyuncular"
L.finish_score_timelimit = "Süre doldu"
L.finish_score_dead_enemies = "Ölü düşmanlar"
L.kill_score = "Öldürme"
L.bodyfound_score = "Ceset bulundu"

L.title_event_bodyfound = "Bir ceset bulundu"
L.title_event_c4_disarm = "Bir C4 devre dışı bırakıldı"
L.title_event_c4_explode = "Bir C4 patladı"
L.title_event_c4_plant = "Bir C4 kuruldu"
L.title_event_creditfound = "Ekipman kredileri bulundu"
L.title_event_finish = "Raunt sona erdi"
L.title_event_game = "Yeni bir raunt başladı"
L.title_event_kill = "Bir oyuncu öldürüldü"
L.title_event_respawn = "Bir oyuncu yeniden doğdu"
L.title_event_rolechange = "Bir oyuncu rolünü veya takımını değiştirdi"
L.title_event_selected = "Roller dağıtıldı"
L.title_event_spawn = "Bir oyuncu doğdu"

L.desc_event_bodyfound = "{finder} ({firole} {fiteam}), {found} ({forole} {foteam}) adlı kişinin cesedini buldu. Cesedin {credits} ekipman kredisi var."
L.desc_event_bodyfound_headshot = "Kurban kafadan vurularak öldürüldü."
L.desc_event_c4_disarm_success = "{disarmer} ({drole} {dteam}), {owner} ({orole} {oteam}) tarafından kurulan C4'ü başarıyla etkisiz hale getirdi."
L.desc_event_c4_disarm_failed = "{disarmer} ({drole} {dteam}), {owner} ({orole} {oteam}) tarafından kurulan C4'ü etkisiz hale getirmeye çalıştı. Başarısız oldular."
L.desc_event_c4_explode = "{owner} ({role} {team}) tarafından kurulan C4 patladı."
L.desc_event_c4_plant = "{owner} ({role} {team}), bir C4 patlayıcı kurdu."
L.desc_event_creditfound = "{finder} ({firole} {fiteam}), {found} ({forole} {foteam}) cesedinde {credits} ekipman kredisi buldu."
L.desc_event_finish = "Raunt {minutes}{seconds} sürdü. Sonunda {alive} oyuncu hayatta kaldı."
L.desc_event_game = "Yeni bir raunt başladı."
L.desc_event_respawn = "{player} yeniden canlandı."
L.desc_event_rolechange = "{player}, {orole} ({oteam}) olan rol takımını {nrole} ({nteam}) olarak değiştirdi."
L.desc_event_selected = "Takımlar ve roller tüm {amount} oyuncu için dağıtıldı."
L.desc_event_spawn = "{player} doğdu."

-- Name of a trap that killed us that has not been named by the mapper
L.trap_something = "bir şey"

-- Kill events
L.desc_event_kill_suicide = "Bir intihar vakası."
L.desc_event_kill_team = "Bu bir takım öldürmesiydi."

L.desc_event_kill_blowup = "{victim} ({vrole} {vteam}) kendini havaya uçurdu."
L.desc_event_kill_blowup_trap = "{victim} ({vrole} {vteam}), {trap} tarafından havaya uçuruldu."

L.desc_event_kill_tele_self = "{victim} ({vrole} {vteam}) kendilerini ışınlanarak öldürdüler."
L.desc_event_kill_sui = "{victim} ({vrole} {vteam}) bunu kaldıramadı ve kendini öldürdü."
L.desc_event_kill_sui_using = "{victim} ({vrole} {vteam}), {tool} kullanarak kendini öldürdü."

L.desc_event_kill_fall = "{victim} ({vrole} {vteam}) ölümüne düştü."
L.desc_event_kill_fall_pushed = "{victim} ({vrole} {vteam}, {attacker} onları ittikten sonra ölüme düştü."
L.desc_event_kill_fall_pushed_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) onları itmek için {trap} kullandıktan sonra ölümüne düştü."

L.desc_event_kill_shot = "{victim} ({vrole} {vteam}), {attacker} tarafından vuruldu."
L.desc_event_kill_shot_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) tarafından bir {weapon} kullanılarak vuruldu."

L.desc_event_kill_drown = "{victim} ({vrole} {vteam}), {attacker} tarafından boğuldu."
L.desc_event_kill_drown_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) tarafından tetiklenen {trap} tarafından boğuldu."

L.desc_event_kill_boom = "{victim} ({vrole} {vteam}), {attacker} tarafından havaya uçuruldu."
L.desc_event_kill_boom_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından havaya uçuruldu."

L.desc_event_kill_burn = "{victim} ({vrole} {vteam}) / {attacker} tarafından vuruldu."
L.desc_event_kill_burn_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) nedeniyle {trap} tarafından yakıldı."

L.desc_event_kill_club = "{victim} ({vrole} {vteam}), {attacker} tarafından dövüldü."
L.desc_event_kill_club_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından dövülerek öldürüldü."

L.desc_event_kill_slash = "{victim} ({vrole} {vteam}), {attacker} tarafından bıçaklandı."
L.desc_event_kill_slash_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından havaya uçuruldu."

L.desc_event_kill_tele = "{victim} ({vrole} {vteam}), {attacker} tarafından ışınlanarak öldürüldü."
L.desc_event_kill_tele_using = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) tarafından ayarlanan {trap} tarafından atomlarına ayrıldı."

L.desc_event_kill_goomba = "{victim} ({vrole} {vteam}), {attacker} ({arole} {ateam}) kendi cüssesiyle onu ezdi."

L.desc_event_kill_crush = "{victim} ({vrole} {vteam}), {attacker} tarafından ezildi."
L.desc_event_kill_crush_using = "{victim} ({vrole} {vteam}), {trap} aracılıyla {attacker} ({arole} {ateam}) tarafından ezildi."

L.desc_event_kill_other = "{victim} ({vrole} {vteam}), {attacker} tarafından öldürüldü."
L.desc_event_kill_other_using = "{victim} ({vrole} {vteam}), {trap} kullanılarak {attacker} ({arole} {ateam}) tarafından havaya uçuruldu."

-- 2021-04-20
L.none = "Rol Yok"

-- 2021-04-24
L.karma_teamkill_tooltip = "Öldürülen takım arkadaşı"
L.karma_teamhurt_tooltip = "Hasar verilen takım arkadaşı"
L.karma_enemykill_tooltip = "Öldürülen düşman"
L.karma_enemyhurt_tooltip = "Hasar verilen düşman"
L.karma_cleanround_tooltip = "Raundu Temizle"
L.karma_roundheal_tooltip = "Karma yenileme"
L.karma_unknown_tooltip = "Bilinmiyor"

-- 2021-05-07
L.header_random_shop_administration = "Rastgele Mağaza Ayarları"
L.header_random_shop_value_administration = "Bakiye Ayarları"

L.shopeditor_name_random_shops = "Rastgele mağazaları etkinleştir"
L.shopeditor_desc_random_shops = [[Rastgele mağazalar, her oyuncuya mevcut tüm ekipmanların sınırlı bir rastgele setini verir."
Takım mağazaları, aynı seti bireysel olanlar yerine bir takımdaki tüm oyunculara zorla verir."
Yeniden dağıtma, yeni bir rastgele ekipman seti almanızı sağlar.]]
L.shopeditor_name_random_shop_items = "Rastgele ekipman sayısı"
L.shopeditor_desc_random_shop_items = "Bu, her zaman mağazada mevcut olarak işaretlenmiş ekipmanları içerir. Bu yüzden yeterince yüksek bir sayı seç yoksa sadece onları alırsın."
L.shopeditor_name_random_team_shops = "Takım mağazalarını etkinleştir"
L.shopeditor_name_random_shop_reroll = "Mağaza yeniden dağıtım kullanılabilirliğini etkinleştir"
L.shopeditor_name_random_shop_reroll_cost = "Yeniden dağıtım başına maliyet"
L.shopeditor_name_random_shop_reroll_per_buy = "Satın aldıktan sonra otomatik olarak yeniden dağıt"

-- 2021-06-04
L.header_equipment_setup = "Ekipman Ayarları"
L.header_equipment_value_setup = "Bakiye Ayarları"

L.equipmenteditor_name_not_buyable = "Satın alınabilir"
L.equipmenteditor_desc_not_buyable = "Devre dışı bırakılırsa ekipman mağazada gösterilmez. Bu ekipmanın atandığı roller yine de onu alacaktır."
L.equipmenteditor_name_not_random = "Mağazada her zaman mevcuttur"
L.equipmenteditor_desc_not_random = "Etkinleştirilirse, ekipman her zaman mağazada mevcuttur. Rastgele mağaza etkinleştirildiğinde, mevcut bir rastgele yuva alır ve her zaman bu ekipman için ayırır."
L.equipmenteditor_name_global_limited = "Genel sınırlı miktar"
L.equipmenteditor_desc_global_limited = "Etkinleştirilirse, ekipman aktif rauntta sunucuda yalnızca bir kez satın alınabilir."
L.equipmenteditor_name_team_limited = "Takım sınırlı miktar"
L.equipmenteditor_desc_team_limited = "Etkinleştirilirse, ekipman aktif rauntta takım başına yalnızca bir kez satın alınabilir."
L.equipmenteditor_name_player_limited = "Oyuncu sınırlı miktarı"
L.equipmenteditor_desc_player_limited = "Etkinleştirilirse, ekipman aktif rauntta oyuncu başına yalnızca bir kez satın alınabilir."
L.equipmenteditor_name_min_players = "Satın almak için minimum oyuncu sayısı"
L.equipmenteditor_name_credits = "Kredi cinsinden fiyat"

-- 2021-06-08
L.equip_not_added = "eklenmedi"
L.equip_added = "eklendi"
L.equip_inherit_added = "eklendi (devralma)"
L.equip_inherit_removed = "kaldırıldı (devral)"

-- 2021-06-09
L.layering_not_layered = "Katmanlı değil"
L.layering_layer = "Katman {layer}"
L.header_rolelayering_role = "{role} dağıtımı"
L.header_rolelayering_baserole = "Temel rol dağıtma"
L.submenu_administration_rolelayering_title = "Rol Dağıtma"
L.header_rolelayering_info = "Rol dağıtma bilgileri"
L.help_rolelayering_roleselection = "Rol dağılım süreci iki aşamaya ayrılmıştır. İlk aşamada masum, hain ve aşağıdaki 'temel rol dağıtımı' kutusunda listelenen temel roller dağıtılır. İkinci aşama, bu temel rolleri bir alt role yükseltmek için kullanılır."
L.help_rolelayering_layers = "Her dağıtımdan yalnızca bir rol seçilir. İlk olarak, özel katmanlardan gelen roller, ilk katmandan başlayarak son katmana ulaşılana kadar dağıtılır veya daha fazla rol yükseltilemez. Hangisi önce olursa olsun, yükseltilebilir slotlar hala mevcutsa, katmanlanmamış roller de dağıtılacaktır."
L.scoreboard_voice_tooltip = "Ses seviyesini değiştirmek için kaydırın"

-- 2021-06-15
L.header_shop_linker = "Ayarlar"
L.label_shop_linker_set = "Mağaza türünü seçin"

-- 2021-06-18
L.xfer_team_indicator = "Takım"

-- 2021-06-25
L.searchbar_default_placeholder = "Listede ara..."

-- 2021-07-11
L.spec_about_to_revive = "İzleme, canlanma sırasında sınırlıdır."

-- 2021-09-01
L.spawneditor_name = "Canlanma Noktası Düzenleyici Aracı"
L.spawneditor_desc = "Dünyaya silah, cephane ve oyuncu canlanma noktası yerleştirmek için kullanılır. Yalnızca süper admin tarafından kullanılabilir."

L.spawneditor_place = "Canlanma noktasını yerleştir"
L.spawneditor_remove = "Canlanma noktasını kaldır"
L.spawneditor_change = "Canlanma noktası türünü değiştirin (geri almak için [SHIFT] tuşunu basılı tutun)"
L.spawneditor_ammo_edit = "Otomatik ortaya çıkan cephaneyi düzenlemek için silahın ortaya çıkmasını bekle"

L.spawn_weapon_random = "Rastgele Silah Çıkış Noktası"
L.spawn_weapon_melee = "Yakın Dövüş Silahı Çıkış Noktası"
L.spawn_weapon_nade = "Bomba Çıkış Noktası"
L.spawn_weapon_shotgun = "Pompalı Çıkış Noktası"
L.spawn_weapon_heavy = "Ağır Silah Çıkış Noktası"
L.spawn_weapon_sniper = "Keskin Nişancı Silahı Çıkış Noktası"
L.spawn_weapon_pistol = "Tabanca Silahı Çıkış Noktası"
L.spawn_weapon_special = "Özel Silah Çıkış Noktası"
L.spawn_ammo_random = "Rastgele Cephane Çıkış Noktası"
L.spawn_ammo_deagle = "Deagle Cephanesi Çıkış Noktası"
L.spawn_ammo_pistol = "Tabanca Cephanesi Çıkış Noktası"
L.spawn_ammo_mac10 = "Mac10 Cephanesi Çıkış Noktası"
L.spawn_ammo_rifle = "Tüfek Cephanesi Çıkış Noktası"
L.spawn_ammo_shotgun = "Pompalı Cephanesi Çıkış Noktası"
L.spawn_player_random = "Rastgele Oyuncu Canlanma Noktası"

L.spawn_weapon_ammo = "(Cephane {ammo})"

L.spawn_weapon_edit_ammo = "Bu silahın çıkış noktasında cephaneyi artırmak veya azaltmak için [{walkkey}] tuşunu basılı tutun ve [{primaryfire} veya {secondaryfire}] tuşuna basın"

L.spawn_type_weapon = "Bu bir silah çıkış noktasıdır"
L.spawn_type_ammo = "Bu bir cephane çıkış noktasıdır"
L.spawn_type_player = "Bu bir oyuncu canlanma noktasıdır"

L.spawn_remove = "Bu çıkış noktasını kaldırmak için [{secondaryfire}] tuşuna basın"

L.submenu_administration_entspawn_title = "Çıkış Noktası Düzenleyici"
L.header_entspawn_settings = "Çıkış Noktası Düzenleyici Ayarları"
L.button_start_entspawn_edit = "Çıkış Noktası Düzenlemesini Başlat"
L.button_delete_all_spawns = "Tüm Çıkış Noktalarını Sil"

L.label_dynamic_spawns_enable = "Bu harita için dinamik çıkış noktalarını etkinleştir"
L.label_dynamic_spawns_global_enable = "Tüm haritalar için dinamik çıkış noktalarını etkinleştir"

L.header_equipment_weapon_spawn_setup = "Silah Çıkış Ayarları"

L.help_spawn_editor_info = [[
Çıkış noktası düzenleyicisi, dünyadaki çıkış noktalarını yerleştirmek, kaldırmak ve düzenlemek için kullanılır. Bu çıkış noktaları silahlar, cephaneler ve oyuncular içindir.

Bu çıkış noktaları, 'datatttweaponspawnscripts' içinde bulunan dosyalara kaydedilir. Donanım sıfırlaması için silinebilirler. İlk çıkış noktası dosyaları, haritada ve orijinal TTT silah çıkış noktası komut dosyalarında bulunan çıkış noktalarından oluşturulur. Sıfırlama düğmesine basıldığında her zaman başlangıç durumuna geri dönülür.

Bu çıkış noktası sisteminin dinamik çıkışları kullandığı unutulmamalıdır. Bu, silahlar için en ilginç olanıdır, çünkü artık belirli bir silahı değil, bir tür silahı tanımlar. Örneğin, bir TTT pompalı çıkış noktası yerine, artık pompalı olarak tanımlanan herhangi bir silahın çıkabileceği genel bir pompalı çıkış noktası var. Her silah için çıkış türü 'Ekipmanı Düzenle' menüsünden ayarlanabilir. Bu, herhangi bir silahın haritada ortaya çıkmasını veya belirli varsayılan silahları devre dışı bırakmasını mümkün kılar.

Birçok değişikliğin ancak yeni bir raunt başladıktan sonra yürürlüğe gireceğini unutmayın.]]
L.help_spawn_editor_enable = "Bazı haritalarda, haritada bulunan orijinal çıkış noktalarının dinamik sistemle değiştirilmeden kullanılması önerilebilir. Aşağıdaki bu seçeneğin değiştirilmesi yalnızca şu anda etkin olan haritayı etkiler, bu nedenle dinamik sistem diğer tüm haritalar için kullanılmaya devam edecektir."
L.help_spawn_editor_hint = "İpucu ÇN düzenleyicisinden çıkmak için oyun modu menüsünü yeniden açın."
L.help_spawn_editor_spawn_amount = [[
Şu anda bu haritada {weapon} silah çıkışı, {ammo} cephane çıkışı ve {player} oyuncu canlanma noktaları var.
Bu miktarı değiştirmek için 'ÇN düzenlemesini başlat'a tıklayın.

{weaponrandom}x Rastgele Silah Çıkışı
{weaponmelee}x Yakın Dövüş Silahı Çıkışı
{weaponnade}x El Bombası Çıkışı
{weaponshotgun}x Pompalı Silahı Çıkışı
{weaponheavy}x Ağır Silah Çıkışı
{weaponsniper}x Keskin Nişancı Silahı Çıkışı
{weaponpistol}x Tabanca Silahı Çıkışı
{weaponspecial}x Özel Silah Çıkışı

{ammorandom}x Rastgele Cephane Çıkışı
{ammodeagle}x Deagle Cephane Çıkışı
{ammopistol}x Tabanca Cephane Çıkışı
{ammomac10}x Mac10 Cephane Çıkışı
{ammorifle}x Tüfek Cephane Çıkışı
{ammoshotgun}x Pompalı Cephane Çıkışı

{playerrandom}x Rastgele Oyuncu Canlanması]]

L.equipmenteditor_name_auto_spawnable = "Ekipman dünyada rastgele ortaya çıkar"
L.equipmenteditor_name_spawn_type = "Canlanma türünü seçin"
L.equipmenteditor_desc_auto_spawnable = [[
TTT2 çıkış noktası sistemi, dünyadaki her silahın çıkmasına izin verir. Varsayılan olarak, yalnızca yaratıcı tarafından 'Otomatik Çıkabilir' olarak işaretlenen silahlar dünyada ortaya çıkacaktır, ancak bu menüden değiştirilebilir.

Ekipmanın çoğu, varsayılan olarak 'özel silahların ortaya çıkmasına' ayarlanmıştır. Bu, ekipmanın yalnızca rastgele silah çıkışlarında ortaya çıktığı anlamına gelir. Bununla birlikte, mevcut diğer çıkış türlerini kullanmak için dünyaya özel silah çıkış noktaları yerleştirmek veya burada çıkış noktası türünü değiştirmek mümkündür.]]

L.pickup_error_inv_cached = "Envanteriniz önbelleğe alındığı için şu anda bunu alamazsınız."

-- 2021-09-02
L.submenu_administration_playermodels_title = "Oyuncu Modelleri"
L.header_playermodels_general = "Genel Oyuncu Modeli Ayarları"
L.header_playermodels_selection = "Oyuncu Modeli Havuzunu Seçin"

L.label_enforce_playermodel = "Rol oyuncu modelini uygula"
L.label_use_custom_models = "Rastgele seçilen bir oyuncu modeli kullan"
L.label_prefer_map_models = "Varsayılan modeller yerine haritaya özgü modelleri tercih edin"
L.label_select_model_per_round = "Her rauntta yeni bir rastgele model seçin (devre dışı bırakılmışsa yalnızca harita değişikliğinde)"

L.help_prefer_map_models = [[
Bazı haritalar kendi oyuncu modellerini tanımlar. Varsayılan olarak, bu modeller otomatik olarak atananlardan daha yüksek bir önceliğe sahiptir. Bu ayar devre dışı bırakıldığında, haritaya özgü modeller devre dışı bırakılır.

Role özgü modeller her zaman daha yüksek önceliğe sahiptir ve bu ayardan etkilenmez.]]
L.help_enforce_playermodel = [[
Bazı rollerin özel oyuncu modelleri vardır. Bazı oyuncu modeli seçicileriyle uyumluluk için uygun olabilecek şekilde devre dışı bırakılabilirler.
Bu ayar devre dışı bırakılırsa, rastgele varsayılan modeller yine de seçilebilir.]]
L.help_use_custom_models = [[
Varsayılan olarak tüm oyunculara yalnızca CSS Phoenix oyuncu modeli atanır. Ancak bu seçeneği etkinleştirerek bir oyuncu modeli havuzu seçmek mümkündür. Bu ayar etkinleştirildiğinde, her oyuncuya yine aynı oyuncu modeli atanacaktır, ancak tanımlanan model havuzundan rastgele bir modeldir.

Model seçimleri daha fazla oyuncu modeli yükleyerek genişletilebilir.]]

-- 2021-10-06
L.menu_server_addons_title = "Sunucu Eklentileri"
L.menu_server_addons_description = "Sunucu genelinde yalnızca eklentiler için admin ayarları."

L.tooltip_finish_score_penalty_alive_teammates = "Canlı takım arkadaşlarının cezası {score}"
L.finish_score_penalty_alive_teammates = "Canlı takım arkadaşlarının cezası"
L.tooltip_kill_score_suicide = "İntihar {score}"
L.kill_score_suicide = "İntihar"
L.tooltip_kill_score_team = "Takım arkadaşı öldürme {score}"
L.kill_score_team = "Takım arkadaşı öldürme"

-- 2021-10-09
L.help_models_select = [[
Oyuncu modeli havuzuna eklemek için modellere sol tıklayın. Kaldırmak için tekrar sol tıklayın. Odaklanan model için etkin ve devre dışı dedektif şapkaları arasında sağ tıklama geçiş yapar.

Sol üstteki küçük gösterge, oyuncu modelinin bir kafa vuruş kutusuna sahip olup olmadığını gösterir. Aşağıdaki simge, bu modelin bir dedektif şapkası için geçerli olup olmadığını gösterir.]]

L.menu_roles_title = "Rol Ayarları"
L.menu_roles_description = "Çıkış noktalarını, ekipman kredilerini ve daha fazlasını ayarla."

L.submenu_administration_roles_general_title = "Genel Rol Ayarları"

L.header_roles_info = "Rol Bilgileri"
L.header_roles_selection = "Rol Seçim Parametreleri"
L.header_roles_tbuttons = "Hain Düğmelerine Erişim"
L.header_roles_credits = "Rol Ekipmanı Kredileri"
L.header_roles_additional = "Ek Rol Ayarları"
L.header_roles_reward_credits = "Ödül Ekipmanı Kredileri"

L.help_roles_default_team = "Varsayılan takım {team}"
L.help_roles_unselectable = "Bu rol dağıtılamaz. Rol dağılım sürecinde dikkate alınmaz. Çoğu zaman bu, bunun bir canlanma, bir yardımcı deagle veya benzeri bir olay aracılığıyla raunt sırasında manuel olarak atanan bir rol olduğu anlamına gelir."
L.help_roles_selectable = "Bu rol dağıtılabilir. Tüm kriterlerin karşılanması durumunda bu rol, rol dağılımı sürecinde dikkate alınır."
L.help_roles_credits = "Ekipman kredileri, mağazadan ekipman satın almak için kullanılır. Onlara yalnızca mağazalara erişimi olan roller için vermek çoğunlukla mantıklıdır. Bununla birlikte, cesetler üzerinde kredi bulmak mümkün olduğundan, katillerine ödül olarak rollere başlangıç kredisi de verebilirsiniz."
L.help_roles_selection_short = "Oyuncu başına rol dağılımı, bu role atanan oyuncuların yüzdesini tanımlar. Örneğin, değer '0.2' olarak ayarlanırsa, her beşinci oyuncu bu rolü alır."
L.help_roles_selection = [[
Oyuncu başına rol dağılımı, bu role atanan oyuncuların yüzdesini tanımlar. Örneğin, değer '0.2' olarak ayarlanırsa, her beşinci oyuncu bu rolü alır. Bu aynı zamanda bu rolün dağıtılması için en az 5 oyuncunun gerekli olduğu anlamına gelir.
Tüm bunların yalnızca rolün dağıtım süreci için dikkate alınması durumunda geçerli olduğunu unutmayın.

Söz konusu rol dağılımı, oyuncuların alt sınırı ile özel bir entegrasyona sahiptir. Rol dağıtım için düşünülürse ve minimum değer dağıtım faktörünün verdiği değerin altındaysa, ancak oyuncu miktarı alt sınıra eşit veya daha büyükse, tek bir oyuncu yine de bu rolü alabilir. Dağıtım süreci daha sonra ikinci oyuncu için her zamanki gibi çalışır.]]
L.help_roles_award_info = "Bazı roller (kredi ayarlarında etkinleştirilmişse), düşmanların belirli bir yüzdesi öldüğünde ekipman kredisi alır. İlgili değerler burada düzeltilebilir."
L.help_roles_award_pct = "Düşmanların bu yüzdesi öldüğünde, belirli rollere ekipman kredisi verilir."
L.help_roles_award_repeat = "Kredi ödülünün birden çok kez verilip verilmediği. Örneğin, yüzde '0.25' olarak ayarlanırsa ve bu ayar etkinleştirilirse, oyunculara sırasıyla '%25', '%50' ve '%75' ölü düşmanlarda kredi verilecektir."
L.help_roles_advanced_warning = "UYARI Bunlar, rol dağıtım sürecini tamamen bozabilecek gelişmiş ayarlardır. Şüpheye düştüğünüzde tüm değerleri '0' da tutun. Bu değer, herhangi bir sınır uygulanmadığı ve rol dağılımının mümkün olduğunca çok rol atamaya çalışacağı anlamına gelir."
L.help_roles_max_roles = [[
Buradaki roller terimi hem temel rolleri hem de alt rolleri içerir. Varsayılan olarak, kaç farklı rolün atanabileceği konusunda bir sınır yoktur. Ancak, bunları sınırlamanın iki farklı yolu vardır.

1. Sabit bir miktarla sınırlayın.
2. Onları bir yüzde ile sınırlayın.

İkincisi, yalnızca sabit miktar '0' ise ve mevcut oyuncuların ayarlanan yüzdesine göre bir üst sınır belirlerse kullanılır.]]
L.help_roles_max_baseroles = [[
Temel roller yalnızca başkalarının devraldığı rollerdir. Örneğin, Masum rolü temel bir roldür, Firavun ise bu rolün bir alt rolüdür. Varsayılan olarak, kaç farklı rolün atanabileceği konusunda bir sınır yoktur. Ancak, bunları sınırlamanın iki farklı yolu vardır.

1. Sabit bir miktarla sınırlayın.
2. Onları bir yüzde ile sınırlayın.

İkincisi, yalnızca sabit miktar '0' ise ve mevcut oyuncuların ayarlanan yüzdesine göre bir üst sınır belirlerse kullanılır.]]

L.label_roles_enabled = "Rolü etkinleştir"
L.label_roles_min_inno_pct = "Oyuncu başına masum dağılımı"
L.label_roles_pct = "Oyuncu başına rol dağılımı"
L.label_roles_max = "Bu rol için atanan oyuncuların üst sınırı"
L.label_roles_random = "Bu rolün dağıtılma şansı"
L.label_roles_min_players = "Dağıtımı göz önünde bulundurmak için oyuncuların alt sınırı"
L.label_roles_tbutton = "Rol, Hain düğmelerini kullanabilir"
L.label_roles_credits_starting = "Başlangıç kredileri"
L.label_roles_credits_award_pct = "Kredi ödül yüzdesi"
L.label_roles_credits_award_size = "Kredi ödülü boyutu"
L.label_roles_credits_award_repeat = "Kredi ödülü tekrarı"
L.label_roles_newroles_enabled = "Özel rolleri etkinleştir"
L.label_roles_max_roles = "Üst rol sınırı"
L.label_roles_max_roles_pct = "Yüzde olarak üst rol sınırı"
L.label_roles_max_baseroles = "Üst temel rol sınırı"
L.label_roles_max_baseroles_pct = "Yüzde olarak üst temel rol sınırı"
L.label_detective_hats = "Dedektif gibi polislik rolleri için şapkaları etkinleştir (oyuncu modeli izin veriyorsa)"

L.ttt2_desc_innocent = "Bir Masum, hiçbir özel yeteneğe sahip değildir. Teröristler arasında kötüleri bulup öldürmek zorundalar. Ama takım arkadaşlarını öldürmemeye dikkat etmek zorundalar."
L.ttt2_desc_traitor = "Hain, Masumların düşmanıdır. Özel ekipman satın alabilecekleri bir ekipman menüsü vardır. Takım arkadaşları hariç herkesi öldürmek zorundalar."
L.ttt2_desc_detective = "Masumların güvenebileceği kişi Dedektiftir. Ama Masum bile olsa, kudretli Dedektif tüm kötü teröristleri bulmak zorundadır. Mağazalarındaki ekipmanlar bu görevde onlara yardımcı olabilir."

-- 2021-10-10
L.button_reset_models = "Oynatıcı Modellerini Sıfırla"

-- 2021-10-13
L.help_roles_credits_award_kill = "Kredi kazanmanın bir başka yolu da Dedektif gibi 'herkese açık bir rolü' olan yüksek değerli oyuncuları öldürmektir. Eğer katilin rolü bunu etkinleştirdiyse, aşağıda tanımlanan miktarda kredi kazanır."
L.help_roles_credits_award = [[
Temel TTT2'de kredi almanın iki farklı yolu vardır

1. Düşman takımın belirli bir yüzdesi ölmüşse, tüm takıma kredi verilir.
2. Bir oyuncu, Dedektif gibi 'herkese açık bir role' sahip yüksek değerli bir oyuncuyu öldürdüyse, katile kredi verilir.

Tüm takım ödüllendirilse bile bunun yine de her rol için etkinleştirilebileceğini lütfen unutmayın. Örneğin, Masum takımı ödüllendirilirse, ancak Masum rolünün bu özelliği devre dışı bırakılmışsa, kredilerini yalnızca Dedektif alacaktır.
Bu özelliğin dengeleme değerleri 'Yönetim' - 'Genel Rol Ayarları' bölümünden ayarlanabilir.]]
L.help_detective_hats = [[
Dedektif gibi polislik rolleri, yetkilerini göstermek için şapka takabilir. Onları öldüklerinde veya kafadan hasar gördüklerinde kaybederler.

Bazı oyuncu modelleri varsayılan olarak şapkaları desteklemez. Bu, 'Yönetim' - 'Oyuncu Modelleri' bölümünden değiştirilebilir]]

L.label_roles_credits_award_kill = "Öldürme için kredi ödülü"
L.label_roles_credits_dead_award = "Ölü düşmanların belirli bir yüzdesi için kredi ödülünü etkinleştir"
L.label_roles_credits_kill_award = "Yüksek değerli oyuncu öldürme için kredi ödülünü etkinleştir"
L.label_roles_min_karma = "Dağılımı göz önünde bulundurmak için Karma'nın alt sınırı"

-- 2021-11-07
L.submenu_administration_administration_title = "Yönetim"
L.submenu_administration_voicechat_title = "Sesli sohbet Metin sohbeti"
L.submenu_administration_round_setup_title = "Raunt Ayarları"
L.submenu_administration_mapentities_title = "Harita Varlıkları"
L.submenu_administration_inventory_title = "Envanter"
L.submenu_administration_karma_title = "Karma"
L.submenu_administration_sprint_title = "Koşma"
L.submenu_administration_playersettings_title = "Oyuncu Ayarları"

L.header_roles_special_settings = "Özel Rol Ayarları"
L.header_equipment_additional = "Ek Ekipman Ayarları"
L.header_administration_general = "Genel Yönetim Ayarları"
L.header_administration_logging = "Günlük Kaydı"
L.header_administration_misc = "Diğer"
L.header_entspawn_plyspawn = "Oyuncu Canlanma Ayarları"
L.header_voicechat_general = "Genel Sesli Sohbet Ayarları"
L.header_voicechat_battery = "Sesli Sohbet Pili"
L.header_voicechat_locational = "Sesli Sohbet Mesafesi"
L.header_playersettings_plyspawn = "Oyuncu Canlanma Ayarları"
L.header_round_setup_prep = "Raunt Hazırlığı"
L.header_round_setup_round = "Raunt Aktif"
L.header_round_setup_post = "Raunt Sonu"
L.header_round_setup_map_duration = "Harita Oturumu"
L.header_textchat = "Metin sohbeti"
L.header_round_dead_players = "Ölü Oyuncu Ayarları"
L.header_administration_scoreboard = "Puan Tablosu Ayarları"
L.header_hud_toggleable = "Değiştirilebilir Arayüz Öğeleri"
L.header_mapentities_prop_possession = "Nesne Kontrolü"
L.header_mapentities_doors = "Kapılar"
L.header_karma_tweaking = "Karma Düzenlemesi"
L.header_karma_kick = "Sunucudan Atma ve Yasaklama Karması"
L.header_karma_logging = "Karma Günlüğü"
L.header_inventory_gernal = "Envanter Boyutu"
L.header_inventory_pickup = "Envanter Silah Toplama"
L.header_sprint_general = "Koşma Ayarları"
L.header_playersettings_armor = "Zırh Sistemi Ayarları"

L.help_killer_dna_range = "Bir oyuncu başka bir oyuncu tarafından öldürüldüğünde, cesedinde bir DNA örneği kalır. Aşağıdaki ayar, bırakılacak DNA numuneleri için hammer ünitelerindeki maksimum mesafeyi tanımlar. Kurban öldüğünde katil bu değerden daha uzaktaysa, ceset üzerinde hiçbir örnek kalmayacaktır."
L.help_killer_dna_basetime = "Katil 0 hammer birimi uzaktaysa, bir DNA örneği bozulana kadar saniye cinsinden baz süre. Katil ne kadar uzaktaysa, DNA örneğinin çürümesi için o kadar az zaman verilecektir."
L.help_dna_radar = "TTT2 DNA tarayıcısı, varsa seçilen DNA örneğinin tam mesafesini ve yönünü gösterir. Bununla birlikte, bekleme süresi her geçtiğinde seçilen numuneyi bir dünya içi render ile güncelleyen klasik bir DNA tarayıcı modu da vardır."
L.help_idle = "Boşta modu, boşta kalan oyuncuları izleyici moduna zorlamak için kullanılır. Bu moddan çıkmak için 'oyun' menüsünde devre dışı bırakmaları gerekir."
L.help_namechange_kick = [[
Aktif bir raunt sırasında isim değişikliği kötüye kullanılabilir. Bu nedenle, bu varsayılan olarak yasaktır ve suç işleyen oyuncunun sunucudan atılmasına neden olacaktır.

Yasaklama süresi 0'dan büyükse, oyuncu bu süre geçene kadar sunucuya yeniden bağlanamaz.]]
L.help_damage_log = "Bir oyuncu her hasar aldığında, etkinleştirilirse konsola bir hasar kaydı girişi eklenir. Bu, bir raunt sona erdikten sonra da diske kaydedilebilir. Dosya 'dataterrortownlogs' adresinde bulunur"
L.help_spawn_waves = [[
Bu değişken 0 olarak ayarlanırsa, tüm oyuncular bir kerede ortaya çıkar. Çok sayıda oyuncuya sahip sunucular için, oyuncuları dalgalar halinde canlandırmak faydalı olabilir. Canlandırma dalgası aralığı, her bir canlanma dalgası arasındaki süredir. Bir canlanma dalgası, geçerli canlanma noktaları olduğu sürece her zaman çok sayıda oyuncu canlandırır.

Not: Hazırlama süresinin istenen miktarda canlanma dalgası için yeterince uzun olduğundan emin olun.]]
L.help_voicechat_battery = [[
Etkinleştirilmiş sesli sohbet pili ile sesli sohbet, pil şarjını azaltır. Bittiğinde, oyuncu sesli sohbeti kullanamaz ve şarj olmasını beklemek zorundadır. Bu, aşırı sesli sohbet kullanımını önlemeye yardımcı olabilir.

Not: 'Tik' bir oyun tikini ifade eder. Örneğin, tik hızı 66 olarak ayarlanırsa, saniyenin 166'sı olacaktır.]]
L.help_ply_spawn = "Oyuncu (yeniden) canlanışında kullanılan oyuncu ayarları."
L.help_haste_mode = [[
Hız modu, her ölü oyuncu ile raunt süresini artırarak oyunu dengeler. Yalnızca eylemsiz oyuncularda eksik olan roller gerçek raunt zamanını görebilir. Diğer tüm roller yalnızca hız modu başlangıç zamanını görebilir.

Hız modu etkinleştirilirse, sabit raunt süresi göz ardı edilir.]]
L.help_round_limit = "Ayarlanan sınır koşullarından biri karşılandıktan sonra, bir harita değişikliği tetiklenir."
L.help_armor_balancing = "Zırhı dengelemek için aşağıdaki değerler kullanılabilir."
L.help_item_armor_classic = "Klasik zırh modu etkinleştirilmişse, yalnızca önceki ayarlar önemlidir. Klasik zırh modu, bir oyuncunun bir turda yalnızca bir kez zırh satın alabileceği ve bu zırhın gelen mermi ve levye hasarının %30'unu ölene kadar bloke ettiği anlamına gelir."
L.help_item_armor_dynamic = [[
Dinamik zırh, zırhı daha ilginç hale getirmek için TTT2 yaklaşımıdır. Satın alınabilecek zırh miktarı artık sınırsızdır ve zırh değeri birikir. Hasar almak, zırh değerini azaltır. Satın alınan zırh öğesi başına zırh değeri, söz konusu öğenin 'Ekipman Ayarları'nda ayarlanır.

Hasar alırken, bu hasarın belirli bir yüzdesi zırh hasarına dönüştürülür, oyuncuya hala farklı bir yüzde uygulanır ve geri kalanı kaybolur.

Güçlendirilmiş zırh etkinleştirilirse, zırh değeri takviye eşiğinin üzerinde olduğu sürece oyuncuya uygulanan hasar %15 azaltılır.]]
L.help_sherlock_mode = "Sherlock modu klasik TTT modudur. Sherlock modu devre dışı bırakılırsa, cesetler onaylanamaz, puan tablosu herkesi canlı olarak gösterir ve izleyiciler yaşayan oyuncularla konuşabilir."
L.help_prop_possession = [[
Nesne kontrolü, izleyiciler tarafından dünyada bulunan nesneleri kontrol etmek için kullanılabilir ve söz konusu nesneyi hareket ettirmek için yavaş şarj olan 'güç ölçeri' kullanılabilir."

'Güç Ölçeri'nin maksimum değeri, tanımlanmış iki sınır arasına sıkıştırılmış ölüm farkının eklendiği bir topa sahip olma temel değerinden oluşur. Sayaç zamanla yavaş yavaş şarj olur. Ayarlanan şarj süresi, 'güç ölçerde' tek bir noktayı şarj etmek için gereken süredir.]]
L.help_karma = "Oyuncular belirli miktarda Karma ile başlar ve takım arkadaşlarına zarar verdiklerinde kaybederler. Kaybettikleri miktar, hasar verdikleri veya öldürdükleri kişinin Karmasına bağlıdır. Düşük Karma, verilen hasarı azaltır."
L.help_karma_strict = "Katı Karma etkinleştirilirse, Karma düştükçe hasar cezası daha hızlı artar. Kapalı olduğunda, insanlar 800'ün üzerinde kaldığında hasar cezası çok düşüktür. Katı modu etkinleştirmek, Karma'nın gereksiz öldürmeleri caydırmada daha büyük bir rol oynamasını sağlarken, onu devre dışı bırakmak, Karma'nın yalnızca takım arkadaşlarını sürekli olarak öldüren oyunculara zarar verdiği daha \"gevşek\" bir oyunla sonuçlanır."
L.help_karma_max = "Maks. Karmanın değerini 1000'in üzerine ayarlamak, 1000'den fazla Karmaya sahip oyunculara hasar bonusu vermez. Karma sınırı olarak kullanılabilir."
L.help_karma_ratio = "Her ikisi de aynı takımdaysa, kurbanın Karmasının ne kadarının saldırgandan çıkarıldığını hesaplamak için kullanılan hasarın oranı. Bir takım öldürme gerçekleşirse, başka bir ceza uygulanır."
L.help_karma_traitordmg_ratio = "Her ikisi de farklı takımlarda ise, kurbanın Karmasının ne kadarının saldırgana eklendiğini hesaplamak için kullanılan hasarın oranı. Eğer bir düşman öldürülürse, bir bonus daha uygulanır."
L.help_karma_bonus = "Bir rauntta Karma kazanmanın iki farklı pasif yolu da vardır. Birincisi, raunt sonundaki her oyuncuya uygulanan bir karma restorasyonudur. Daha sonra, hiçbir takım arkadaşı bir oyuncu tarafından yaralanmamış veya öldürülmemişse, ikincil bir temiz raunt bonusu verilir."
L.help_karma_clean_half = [[
Bir oyuncunun Karması başlangıç seviyesinin üzerinde olduğunda (yani maksimum Karma bundan daha yüksek olacak şekilde yapılandırıldığında), tüm Karma artışları, Karmalarının başlangıç seviyesinin ne kadar üzerinde olduğuna bağlı olarak azaltılacaktır. Yani ne kadar yüksek olursa o kadar yavaş yükselir."

Bu azalma, başlangıçta hızlı olan üstel bir bozunma eğrisine girer ve artış küçüldükçe yavaşlar. Bu konvar, bonusun hangi noktada yarıya indirildiğini (yani yarılanma ömrünü) belirler. Varsayılan değer 0.25 ile, Karma'nın başlangıç miktarı 1000 ve maksimum 1500 ise ve bir oyuncu Karma 1125'e ((1500 - 1000) 0.25 = "125) sahipse, temiz raunt bonusu 30 2 = "15 olacaktır. Böylece bonusu daha hızlı düşürmek için bu konvarı düşürürsünüz, daha yavaş düşürmek için 1'e yükseltirsiniz.]]
L.help_max_slots = "Yuva başına maksimum silah miktarını ayarlar. '-1 ', sınır olmadığı anlamına gelir."
L.help_item_armor_value = "Dinamik modda zırh ögesinin verdiği zırh değeridir. Klasik mod etkinleştirilirse (bkz. 'Yönetim' - 'Oyuncu Ayarları'), 0'dan büyük her değer mevcut zırh olarak sayılır."

L.label_killer_dna_range = "DNA bırakmak için maksimum öldürme aralığı"
L.label_killer_dna_basetime = "Numune ömrü baz süresi"
L.label_dna_scanner_slots = "DNA numune yuvaları"
L.label_dna_radar = "Klasik DNA tarayıcı modunu etkinleştir"
L.label_dna_radar_cooldown = "DNA tarayıcı bekleme süresi"
L.label_radar_charge_time = "Kullanıldıktan sonra şarj süresi"
L.label_crowbar_shove_delay = "Levye itme işleminden sonra bekleme süresi"
L.label_idle = "Boşta modunu etkinleştir"
L.label_idle_limit = "Saniye cinsinden maksimum boşta kalma süresi"
L.label_namechange_kick = "İsim değiştirildiğinde atmayı etkinleştir"
L.label_namechange_bantime = "Attıktan sonra dakika cinsinden yasaklanan süre"
L.label_log_damage_for_console = "Konsolda hasar günlüğünü etkinleştir"
L.label_damagelog_save = "Hasar kaydını diske kaydet"
L.label_debug_preventwin = "Herhangi bir kazanma koşulunu önleyin [debug]"
L.label_bots_are_spectators = "Botlar her zaman izleyicidir"
L.label_tbutton_admin_show = "Hain düğmelerini yöneticilere göster"
L.label_ragdoll_carrying = "Ragdoll taşımayı etkinleştir"
L.label_prop_throwing = "Nesne fırlatmayı etkinleştir"
L.label_ragdoll_pinning = "Masum olmayan roller için ragdoll sabitlemeyi etkinleştir"
L.label_ragdoll_pinning_innocents = "Masum roller için ragdoll pinlemeyi etkinleştir"
L.label_weapon_carrying = "Silah taşımayı etkinleştir"
L.label_weapon_carrying_range = "Silah taşıma menzili"
L.label_prop_carrying_force = "Nesne kaldırma gücü"
L.label_teleport_telefrags = "Işınlanırken engelleyen oyuncuları öldür"
L.label_allow_discomb_jump = "Bomba atıcı için disko sıçramasına izin ver"
L.label_spawn_wave_interval = "Saniye cinsinden canlanma aralığı"
L.label_voice_enable = "Sesli sohbeti etkinleştir"
L.label_voice_drain = "Sesli sohbet pil özelliğini etkinleştir"
L.label_voice_drain_normal = "Normal oyuncular için tik başına azalma"
L.label_voice_drain_admin = "Yöneticiler ve genel polislik rolleri için tik başına azalma"
L.label_voice_drain_recharge = "Sesli sohbet etmeme işareti başına şarj oranı"
L.label_locational_voice = "Canlı oyuncular için yakın sesli sohbeti etkinleştir"
L.label_armor_on_spawn = "(Yeniden) doğuşta oyuncu zırhı"
L.label_prep_respawn = "Hazırlık aşamasında anında yeniden doğmayı etkinleştir"
L.label_preptime_seconds = "Saniye cinsinden hazırlık süresi"
L.label_firstpreptime_seconds = "Saniye cinsinden ilk hazırlık süresi"
L.label_roundtime_minutes = "Dakika cinsinden sabit raunt süresi"
L.label_haste = "Hız modunu etkinleştir"
L.label_haste_starting_minutes = "Dakika cinsinden hızlı mod başlangıç süresi"
L.label_haste_minutes_per_death = "Ölüm başına dakika cinsinden ek süre"
L.label_posttime_seconds = "Saniye cinsinden raunt sonu süresi"
L.label_round_limit = "Rauntların üst sınırı"
L.label_time_limit_minutes = "Oyun süresinin dakika cinsinden üst sınırı"
L.label_nade_throw_during_prep = "Hazırlık süresi boyunca bomba atmayı etkinleştir"
L.label_postround_dm = "Raunt bittikten sonra ölüm maçını etkinleştir"
L.label_session_limits_enabled = "Oturum sınırlarını etkinleştir"
L.label_spectator_chat = "İzleyicilerin herkesle sohbet etmesini sağla"
L.label_lastwords_chatprint = "Yazarken öldürülürse sohbete son kelimelerini yazdır"
L.label_identify_body_woconfirm = "'Onayla' düğmesine basmadan cesedi tanımla"
L.label_announce_body_found = "Bir ceset bulunduğunu duyurun"
L.label_confirm_killlist = "Onaylanmış cesedin ölüm listesini duyur"
L.label_inspect_detective_only = "Ceset aramasını yalnızca polislik rolleriyle sınırla"
L.label_confirm_detective_only = "Ceset onayını yalnızca polislik rolleriyle sınırlayın"
L.label_dyingshot = "Demir nişangahta ölürken ateş et [deneysel]"
L.label_armor_block_headshots = "Zırh engelleyici kafadan vuruşları etkinleştir"
L.label_armor_block_blastdmg = "Patlama hasarını engelleyen zırhı etkinleştir"
L.label_armor_dynamic = "Dinamik zırhı etkinleştir"
L.label_armor_value = "Zırh öğesi tarafından verilen zırh miktarı"
L.label_armor_damage_block_pct = "Zırhın aldığı hasar yüzdesi"
L.label_armor_damage_health_pct = "Oyuncunun aldığı hasar yüzdesi"
L.label_armor_enable_reinforced = "Güçlendirilmiş zırhı etkinleştir"
L.label_armor_threshold_for_reinforced = "Güçlendirilmiş zırh eşiği"
L.label_sherlock_mode = "Sherlock modunu etkinleştir"
L.label_highlight_admins = "Sunucu yöneticilerini vurgula"
L.label_highlight_dev = "TTT2 geliştiricisini vurgula"
L.label_highlight_vip = "TTT2 destekçisini vurgula"
L.label_highlight_addondev = "TTT2 eklenti geliştiricisini vurgula"
L.label_highlight_supporter = "Diğerlerini vurgula"
L.label_enable_hud_element = "{elem} arayüz öğesini etkinleştir"
L.label_spec_prop_control = "Nesne kontrolünü etkinleştir"
L.label_spec_prop_base = "Kontrol temel değeri"
L.label_spec_prop_maxpenalty = "Daha düşük kontrol bonusu limiti"
L.label_spec_prop_maxbonus = "Üst kontrole sahip olma bonus limiti"
L.label_spec_prop_force = "Kontrol itme kuvveti"
L.label_spec_prop_rechargetime = "Saniye cinsinden şarj süresi"
L.label_doors_force_pairs = "Yakın kapıları çift kapı olarak zorla"
L.label_doors_destructible = "Yok edilebilir kapıları etkinleştir"
L.label_doors_locked_indestructible = "Başlangıçta kilitli kapılar yok edilemez"
L.label_doors_health = "Kapı sağlığı"
L.label_doors_prop_health = "Yok edilen kapı sağlığı"
L.label_minimum_players = "Raunda başlamak için minimum oyuncu miktarı"
L.label_karma = "Karmayı Etkinleştir"
L.label_karma_strict = "Katı Karmayı etkinleştir"
L.label_karma_starting = "Başlangıç Karması"
L.label_karma_max = "Maksimum Karma"
L.label_karma_ratio = "Takım hasarı için ceza oranı"
L.label_karma_kill_penalty = "Takım öldürme için öldürme cezası"
L.label_karma_round_increment = "Karma restorasyonu"
L.label_karma_clean_bonus = "Temiz raunt bonusu"
L.label_karma_traitordmg_ratio = "Düşman hasarı için bonus oranı"
L.label_karma_traitorkill_bonus = "Düşman öldürme bonusu"
L.label_karma_clean_half = "Temiz raunt bonus azaltımı"
L.label_karma_persist = "Harita değişiklikleri üzerinde Karma devam etsin"
L.label_karma_low_autokick = "Karması düşük olan oyuncuları otomatik olarak tekmele"
L.label_karma_low_amount = "Düşük Karma eşiği"
L.label_karma_low_ban = "Düşük Karmaya sahip oyuncuları yasakla"
L.label_karma_low_ban_minutes = "Dakika cinsinden yasaklama süresi"
L.label_karma_debugspam = "Karma değişiklikleri hakkında konsol kurmak için hata ayıklama çıkışını etkinleştir"
L.label_max_melee_slots = "Maksimum yakın dövüş yuvası"
L.label_max_secondary_slots = "Maksimum ikincil yuva"
L.label_max_primary_slots = "Maksimum birincil yuva"
L.label_max_nade_slots = "Maksimum bomba yuvası"
L.label_max_carry_slots = "Maksimum taşıma yuvası"
L.label_max_unarmed_slots = "Maksimum silahsız yuva"
L.label_max_special_slots = "Maksimum özel yuva"
L.label_max_extra_slots = "Maksimum ekstra yuva"
L.label_weapon_autopickup = "Otomatik silah alımını etkinleştir"
L.label_sprint_enabled = "Koşmayı etkinleştir"
L.label_sprint_max = "Maksimum koşma dayanıklılığı"
L.label_sprint_stamina_consumption = "Dayanıklılık tüketim faktörü"
L.label_sprint_stamina_regeneration = "Dayanıklılık yenileme faktörü"
L.label_sprint_crosshair = "Koşarken nişangahı göster"
L.label_crowbar_unlocks = "Birincil saldırı etkileşim (yani kilit açma) olarak kullanılabilir"
L.label_crowbar_pushforce = "Levye itme kuvveti"

-- 2022-07-02
L.header_playersettings_falldmg = "Düşme Hasarı Ayarları"

L.label_falldmg_enable = "Düşme hasarını etkinleştir"
L.label_falldmg_min_velocity = "Düşme hasarının oluşması için minimum hız eşiği"
L.label_falldmg_exponent = "Hıza bağlı olarak düşme hasarını artıran üs"

L.help_falldmg_exponent = [[
Bu değer, oyuncunun yere çarpma hızı ile katlanarak düşme hasarının ne kadar arttığını değiştirir.

Bu değeri değiştirirken dikkatli olun. Çok yükseğe ayarlamak en küçük düşüşleri bile ölümcül hale getirebilirken, çok düşük ayarlamak oyuncuların aşırı yüksekliklerden düşmesine ve çok az hasar görmesine veya hiç hasar görmemesine izin verecektir.]]

-- 2023-02-08
L.testpopup_title = "Çok satırlı bir başlık içeren bir test açılır penceresi, ne GÜZEL!"
L.testpopup_subtitle = "Aa merhaba! Bu, bazı özel bilgiler içeren süslü bir açılır penceredir. Metin çok satırlı da olabilir, ne kadar süslü! Off, herhangi bir fikrim olsaydı çok daha fazla metin ekleyebilirdim..."

L.hudeditor_chat_hint1 = "[TTT2][BİLGİ] Bir öğenin üzerine gelin, [LMB] tuşuna basın ve basılı tutun ve TAŞIMAK veya YENİDEN BOYUTLANDIRMAK için fareyi hareket ettirin."
L.hudeditor_chat_hint2 = "[TTT2][BİLGİ] Simetrik yeniden boyutlandırma için ALT tuşuna basın ve basılı tutun."
L.hudeditor_chat_hint3 = "[TTT2][BİLGİ] Eksen üzerinde hareket etmek ve en boy oranını korumak için SHIFT tuşunu basılı tutun."
L.hudeditor_chat_hint4 = "[TTT2][BİLGİ] Arayüz Düzenleyiciden çıkmak için [RMB] - 'Kapat'a bas!"

L.guide_nothing_title = "Henüz burada bir şey yok!"
L.guide_nothing_desc = "Bu devam eden bir çalışma, GitHub'daki projeye katkıda bulunarak bize yardımcı olun."

L.sb_rank_tooltip_developer = "TTT2 Geliştirici"
L.sb_rank_tooltip_vip = "TTT2 Destekçisi"
L.sb_rank_tooltip_addondev = "TTT2 Eklenti Geliştirici"
L.sb_rank_tooltip_admin = "Sunucu Yöneticisi"
L.sb_rank_tooltip_streamer = "Yayıncı"
L.sb_rank_tooltip_heroes = "TTT2 Kahramanları"
L.sb_rank_tooltip_team = "Ekip"

L.tbut_adminarea = "YÖNETİCİ ALANI"

-- 2023-08-10
L.equipmenteditor_name_damage_scaling = "Hasar Boyutu"

-- 2023-08-11
L.equipmenteditor_name_allow_drop = "Bırakmaya İzin Ver"
L.equipmenteditor_desc_allow_drop = "Etkinleştirilirse, ekipman oyuncu tarafından serbestçe bırakılabilir."

L.equipmenteditor_name_drop_on_death_type = "Ölürken Bırak"
L.equipmenteditor_desc_drop_on_death_type = "Oyuncunun ölümü üzerine ekipmanın düşürülüp düşürülmediğine ilişkin eylemi geçersiz kılmaya çalışır."

L.drop_on_death_type_default = "Varsayılan (silah tanımlı)"
L.drop_on_death_type_force = "Ölürken Bırakmaya Zorla"
L.drop_on_death_type_deny = "Ölürken Bırakmayı Reddet"

-- 2023-08-26
L.equipmenteditor_name_kind = "Ekipman Yuvası"
L.equipmenteditor_desc_kind = "Ekipmanın olduğu envanter yuvası."

L.slot_weapon_melee = "Yakın Dövüş Yuvası"
L.slot_weapon_pistol = "Tabanca Yuvası"
L.slot_weapon_heavy = "Ağır Silah Yuvası"
L.slot_weapon_nade = "Bomba Yuvası"
L.slot_weapon_carry = "Taşıma Yuvası"
L.slot_weapon_unarmed = "Silahsız Yuva"
L.slot_weapon_special = "Özel Yuva"
L.slot_weapon_extra = "Ekstra Yuva"
L.slot_weapon_class = "Sınıf Yuvası"

-- 2023-10-04
L.label_voice_duck_spectator = "İzleyici seslerini buğula"
L.label_voice_duck_spectator_amount = "İzleyici seslerini buğulama miktarı"
L.label_voice_scaling = "Ses Seviyesi Ölçekleme Modu"
L.label_voice_scaling_mode_linear = "Doğrusal"
L.label_voice_scaling_mode_power4 = "Güç 4"
L.label_voice_scaling_mode_log = "Logaritmik"

-- 2023-10-23
L.header_miscellaneous_settings = "Çeşitli Ayarlar"
L.label_hud_pulsate_health_enable = "Sağlık %25'in altındayken sağlık göstergesini titret"
L.header_hud_elements_customize = "Arayüz Öğelerini Özelleştir"
L.help_hud_elements_special_settings = "Bunlar, kullanılan arayüz öğeleri için özel ayarlardır."

-- 2023-10-25
L.help_keyhelp = [[
Tuş atama yardımcıları, oyuncuya her zaman güncel tuş atamalarını gösteren ve özellikle yeni oyuncular için yararlı olan bir kullanıcı arayüzü öğesinin bir parçasıdır. Üç farklı türde tuş atama vardır

Çekirdek: Bunlar, TTT2'de bulunan en önemli atamaları içerir. Onlar olmadan oyunu tam potansiyeliyle oynamak zordur.
Ekstra Core'a benzer, ancak her zaman onlara ihtiyacınız yoktur. Sohbet, ses veya el feneri gibi şeyler içerirler. Yeni oyuncuların bunu etkinleştirmesi yararlı olabilir.
Ekipman bazı ekipman öğelerinin kendi atamaları vardır, bunlar bu kategoride gösterilmiştir.

Puan tablosu görünür olduğunda devre dışı kategoriler hala gösterilir]]

L.label_keyhelp_show_core = "Her zaman çekirdek atamaları göstermeyi etkinleştir"
L.label_keyhelp_show_extra = "Her zaman ekstra atamaları göstermeyi etkinleştir"
L.label_keyhelp_show_equipment = "Ekipman atamalarını her zaman göstermeyi etkinleştir"

L.header_interface_keys = "Tuş yardımcısı ayarları"
L.header_interface_wepswitch = "Silah değiştirme kullanıcı arayüzü ayarları"

L.label_keyhelper_help = "oyun modu menüsünü aç"
L.label_keyhelper_mutespec = "izleyici ses modunda dön"
L.label_keyhelper_shop = "ekipman mağazasını aç"
L.label_keyhelper_show_pointer = "serbest fare işaretçisi"
L.label_keyhelper_possess_focus_entity = "odaklanılmış varlığı kontrol et"
L.label_keyhelper_spec_focus_player = "odaklı oyuncuyu izle"
L.label_keyhelper_spec_previous_player = "önceki oyuncu"
L.label_keyhelper_spec_next_player = "sonraki oyuncu"
L.label_keyhelper_spec_player = "rastgele oyuncu izle"
L.label_keyhelper_possession_jump = "Nesne: Zıpla"
L.label_keyhelper_possession_left = "Nesne: Sol"
L.label_keyhelper_possession_right = "Nesne: Sağ"
L.label_keyhelper_possession_forward = "Nesne: İleri"
L.label_keyhelper_possession_backward = "Nesne: Geri"
L.label_keyhelper_free_roam = "nesneyi bırakın ve serbest dolaşın"
L.label_keyhelper_flashlight = "El fenerini aç/kapat"
L.label_keyhelper_quickchat = "hızlı sohbeti aç"
L.label_keyhelper_voice_global = "genel sesli sohbet"
L.label_keyhelper_voice_team = "Takım Sesli Sohbeti"
L.label_keyhelper_chat_global = "genel sohbet"
L.label_keyhelper_chat_team = "takım sohbeti"
L.label_keyhelper_show_all = "tümünü göster"
L.label_keyhelper_disguiser = "Kılık Değiştiriciyi aç/kapat"
L.label_keyhelper_save_exit = "kaydet ve çık"
L.label_keyhelper_spec_third_person = "Üçüncü kişi görünümünü aç/kapat"

-- 2023-10-26
L.item_armor_reinforced = "Güçlendirilmiş Zırh"
L.item_armor_sidebar = "Zırh sizi vücudunuza giren mermilere karşı korur. Ama sonsuza kadar değil."
L.item_disguiser_sidebar = "Kılık değiştirici, adınızı diğer oyunculara göstermeyerek kimliğinizi korur."
L.status_speed_name = "Hız Çarpanı"
L.status_speed_description_good = "Normalden daha hızlısın. Eşyalar, ekipmanlar veya etkiler bunu etkileyebilir."
L.status_speed_description_bad = "Normalden daha yavaşsınız. Eşyalar, ekipmanlar veya etkiler bunu etkileyebilir."

L.status_on = "açık"
L.status_off = "Kapalı"

L.crowbar_help_primary = "Saldır"
L.crowbar_help_secondary = "Oyuncuları it"

-- 2023-10-27
L.help_HUD_enable_description = [[
Tuş yardımcısı veya kenar çubuğu gibi bazı arayüz öğeleri, puan tablosu açıkken ayrıntılı bilgi gösterir. Bu, dağınıklığı azaltmak için devre dışı bırakılabilir.]]
L.label_HUD_enable_description = "Puan tablosu açıkken açıklamaları etkinleştir"
L.label_HUD_enable_box_blur = "Arayüz kutusu arka plan bulanıklığını etkinleştir"

-- 2023-10-28
L.submenu_gameplay_voiceandvolume_title = "Ses ve Ses Düzeyi"
L.header_soundeffect_settings = "Ses Efektleri"
L.header_voiceandvolume_settings = "Ses ve Ses Ayarları"

-- 2023-11-06
L.drop_reserve_prevented = "Bir şey yedek cephanenizi düşürmenizi engelliyor."
L.drop_no_reserve = "Rezervinizde cephane kutusu olarak düşecek yeterli cephane yok."
L.drop_no_room_ammo = "Burada silahını bırakacak yerin yok!"

-- 2023-11-14
L.hat_deerstalker_name = "Dedektifin Şapkası"

-- 2023-11-16
L.help_prop_spec_dash = [[
Normal hareketten daha yüksek kuvvette olabilirler. Daha yüksek kuvvet aynı zamanda daha yüksek temel değer tüketimi anlamına gelir.

Bu değişken itme kuvvetinin bir çarpanıdır.]]
L.label_spec_prop_dash = "Atılma kuvveti çarpanı"
L.label_keyhelper_possession_dash = "nesne: bakılan yönde atıl"
L.label_keyhelper_weapon_drop = "mümkünse seçilen silahı bırak"
L.label_keyhelper_ammo_drop = "seçilen silahın şarjöründen cephane çıkar"
