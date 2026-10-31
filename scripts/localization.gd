class_name Localization
extends RefCounted

## Centralized bilingual localization dictionary and helper for Yangon After Hours.
## Supports English ("en") and Burmese / Myanmar Unicode ("my").

const UI_TEXTS: Dictionary = {
	"en": {
		# Main Menu
		"MENU_TITLE": "YANGON AFTER HOURS",
		"MENU_SUBTITLE": "A Point & Click Mystery in the Heart of Myanmar",
		"MENU_PLAY": "▶ Play Game",
		"MENU_QUIT": "Quit",
		"MENU_LANG_BTN": "🌐 Language: English",
		"MENU_FOOTER": "Touch & Mouse Compatible",
		"HOW_TO_PLAY_TITLE": "HOW TO PLAY",
		"HOW_TO_PLAY_DESC": "Tap or click hotspots to explore, speak with characters, and solve interconnected puzzles.",
		
		# City Map
		"MAP_TITLE": "YANGON CITY MAP",
		"MAP_SUBTITLE": "Select an active district to investigate",
		"MAP_BACK_MENU": "← Main Menu",
		"MAP_NOTEBOOK": "📓 Notebook (%d)",
		"MAP_LANG_TOGGLE": "🌐 EN / မြန်မာ",
		
		# District Pin Titles
		"LOC_DOWNTOWN_TITLE": "Downtown (Sule)",
		"LOC_DOWNTOWN_SUB": "Colonial Heritage & Neon Alleyways",
		"LOC_DOWNTOWN_DESC": "Rain-slicked cobblestones reflect golden pagoda spires and glowing vintage shop signs. Cool night breezes rustle through the colonial balconies as late-night taxis hum past Sule Pagoda.",
		
		"LOC_TEA_SHOP_TITLE": "Lucky Tea Shop",
		"LOC_TEA_SHOP_SUB": "Corner of 38th Street",
		"LOC_TEA_SHOP_DESC": "Low plastic stools line the sidewalk under warm incandescent bulbs. The sweet aroma of steamed black tea, condensed milk, and fresh samosas fills the humid night air as patrons discuss the evening news.",
		
		"LOC_MARKET_TITLE": "Night Market",
		"LOC_MARKET_SUB": "Strand Road Waterfront",
		"LOC_MARKET_DESC": "A vibrant labyrinth of stalls beneath striped tarps and string lights along the riverbank. Sizzling charcoal grills, fresh tropical fruits, and bustling vendor shouts echo in the humid night breeze.",
		
		# Location Screen Common
		"BACK_TO_MAP": "← Back to Map",
		"NOTEBOOK_BTN": "📓 Notebook (%d)",
		
		# Dialogue Panel Common
		"DIALOGUE_CONTINUE": "Continue ▶",
		"DIALOGUE_HINT": "Tap anywhere or click Continue to advance",
		
		# Notebook & Investigation Board
		"NOTEBOOK_TITLE": "📓 INVESTIGATION BOARD",
		"NOTEBOOK_SUBTITLE": "Connect Clues, Analyze Evidence & Synthesize Deductions",
		"NOTEBOOK_TAB_CLUES": "🔍 Evidence & Clues (%d)",
		"NOTEBOOK_TAB_DEDUCTIONS": "💡 Deductions (%d)",
		"NOTEBOOK_EMPTY": "No clues collected yet. Explore locations, talk to people, and inspect suspicious objects!",
		"NOTEBOOK_COUNT": "Recorded Clues: %d",
		"NOTEBOOK_DEDUCTION_COUNT": "Case Deductions: %d",
		"NOTEBOOK_CLOSE": "✕ Close",
		"NOTEBOOK_WORKBENCH_TITLE": "🔗 Evidence Synthesis Workbench",
		"NOTEBOOK_WORKBENCH_HINT": "Click any 2 clues above to analyze their connection",
		"NOTEBOOK_SLOT_EMPTY": "+ Select Clue",
		"NOTEBOOK_DEDUCE_BTN": "⚡ Connect Clues",
		"NOTEBOOK_CLEAR_BTN": "↺ Clear",
		"NOTEBOOK_DEDUCTIONS_EMPTY": "No deductions formed yet.\n\nIn the Evidence tab, select and connect two related clues to uncover new deductions!",
		"NOTEBOOK_FEEDBACK_SELECT_TWO": "Select a second clue to attempt a deduction connection.",
		"NOTEBOOK_FEEDBACK_NO_MATCH": "These clues do not appear to connect directly. Review their timeline, location, or details.",
		"NOTEBOOK_FEEDBACK_ALREADY": "You have already connected these clues: %s",
		"NOTEBOOK_FEEDBACK_SUCCESS": "🎉 New Deduction Unlocked: %s!",
		"NOTEBOOK_CONNECTED_LABEL": "Synthesized from: ",
		
		# Clue Notice in Dialogue
		"CLUE_RECORDED": "📓 [ CLUE RECORDED IN NOTEBOOK: %s ]",
		
		# Inspection Panel
		"INSPECT_PROMPT": "Tap or click highlighted areas on the object to investigate details.",
		"INSPECT_CLOSE": "✕ Close",
		"INSPECT_RETURN": "← Back to Room",
		"INSPECT_CLUE_FOUND": "📓 [ NEW CLUE RECORDED: %s ]",
		"INSPECT_CLUE_ALREADY": "📓 [ Already documented in notebook: %s ]",
		"INSPECT_INITIAL_OBS": "Click a highlighted area on the object to examine details.",
		"INSPECT_OBS_TITLE": "✦ Detail Observation",
		"INSPECT_NOTEBOOK_BTN": "📓 Open Notebook (%d)",
		
		# Interactive Questioning & Interrogation
		"QUESTIONING_PRESENT_EVIDENCE": "💼 Present Evidence...",
		"QUESTIONING_LEAVE": "✕ Leave Conversation",
		"QUESTIONING_BACK": "← Back to Questions",
		"QUESTIONING_SELECT_CLUE": "Select a clue from your notebook to present to %s:",
		"QUESTIONING_NO_CLUES": "You haven't collected any clues in your notebook yet.",
		"QUESTIONING_PROMPT_DEFAULT": "How can I help with your investigation, Detective?",
		"QUESTIONING_PROMPT_MORE": "Anything else you would like to ask?"
	},
	"my": {
		# Main Menu
		"MENU_TITLE": "ရန်ကုန်ညဉ့်နက်ချိန်",
		"MENU_SUBTITLE": "မြန်မာပြည်၏ ညဉ့်နက်နက် လျှို့ဝှက်ဆန်းကြယ် စုံထောက်စွန့်စားခန်း",
		"MENU_PLAY": "▶ စတင်ကစားမည်",
		"MENU_QUIT": "ထွက်မည်",
		"MENU_LANG_BTN": "🌐 ဘာသာစကား - မြန်မာစာ",
		"MENU_FOOTER": "မောက်စ်နှင့် ထိတွေ့မျက်နှာပြင် နှစ်မျိုးစလုံး ကစားနိုင်ပါသည်",
		"HOW_TO_PLAY_TITLE": "ကစားနည်း လမ်းညွှန်",
		"HOW_TO_PLAY_DESC": "စူးစမ်းလေ့လာရန်၊ ဇာတ်ကောင်များနှင့် စကားပြောရန်နှင့် ပဟေဠိများ ဖြေရှင်းရန် အရာဝတ္ထုများကို နှိပ်ပါ။",
		
		# City Map
		"MAP_TITLE": "ရန်ကုန်မြို့ပြမြေပုံ",
		"MAP_SUBTITLE": "စုံစမ်းစစ်ဆေးရန် ရပ်ကွက်တစ်ခုကို ရွေးချယ်ပါ",
		"MAP_BACK_MENU": "← ပင်မမီနူး",
		"MAP_NOTEBOOK": "📓 မှတ်စုစာအုပ် (%d)",
		"MAP_LANG_TOGGLE": "🌐 မြန်မာ / EN",
		
		# District Pin Titles
		"LOC_DOWNTOWN_TITLE": "မြို့လယ် (ဆူးလေ)",
		"LOC_DOWNTOWN_SUB": "ကိုလိုနီအမွေအနှစ်နှင့် နီယွန်မီးလမ်းကြားများ",
		"LOC_DOWNTOWN_DESC": "မိုးရေစိုရွှဲနေသော လမ်းခင်းကျောက်ပြားများသည် ရွှေရောင်ဆူးလေစေတီတော်နှင့် တောက်ပနေသော ရှေးဟောင်းဆိုင်ဆိုင်းဘုတ်များကို ပြန်ဟပ်နေသည်။ ညဉ့်နက်အငှားယာဉ်များ ဆူးလေစေတီအနီး ဖြတ်သန်းမောင်းနှင်နေစဉ် ကိုလိုနီခေတ်လသာဆောင်များကြား အေးမြသောညလေညင်း ဖြတ်တိုက်ခတ်နေသည်။",
		
		"LOC_TEA_SHOP_TITLE": "လပ်ကီးလက်ဖက်ရည်ဆိုင်",
		"LOC_TEA_SHOP_SUB": "၃၈ လမ်းထောင့်",
		"LOC_TEA_SHOP_DESC": "မီးသီးဝါဝါလေးများအောက်တွင် ပလတ်စတစ်ခုံနိမ့်လေးများ လူသွားစင်္ကြံတစ်လျှောက် စီတန်းထားသည်။ ရေနွေးငွေ့ထနေသော လက်ဖက်ရည်နက်၊ နို့ဆီနှင့် ပူပူနွေးနွေးစမူဆာတို့၏ မွှေးကြိုင်သောအနံ့သည် ညလေထုထဲ ပျံ့လွင့်နေပြီး လက်ဖက်ရည်ဆိုင်ထိုင်သူများ ညနေခင်းသတင်းစကားများ ပြောဆိုဆွေးနွေးနေကြသည်။",
		
		"LOC_MARKET_TITLE": "ညဈေးတန်း",
		"LOC_MARKET_SUB": "ကမ်းနားလမ်း ဆိပ်ကမ်း",
		"LOC_MARKET_DESC": "မြစ်ကမ်းဘေးတစ်လျှောက် မိုးကာတဲများနှင့် မီးရောင်စုံများအောက်တွင် ဆူညံစည်ကားနေသော ညဈေးတန်းကြီးဖြစ်သည်။ မီးသွေးကင်ဖိုများမှ အသားကင်နံ့များ၊ လတ်ဆတ်သောသစ်သီးများနှင့် ဈေးသည်များ၏ အော်ဟစ်ရောင်းချသံများသည် စိုစွတ်သောညလေညင်းတွင် ပဲ့တင်ထပ်နေသည်။",
		
		# Location Screen Common
		"BACK_TO_MAP": "← မြေပုံသို့ပြန်သွားမည်",
		"NOTEBOOK_BTN": "📓 မှတ်စုစာအုပ် (%d)",
		
		# Dialogue Panel Common
		"DIALOGUE_CONTINUE": "ဆက်သွားမည် ▶",
		"DIALOGUE_HINT": "ရှေ့သို့ဆက်ရန် နေရာလွတ်ကို နှိပ်ပါ သို့မဟုတ် ဆက်သွားမည် ကို နှိပ်ပါ",
		
		# Notebook & Investigation Board
		"NOTEBOOK_TITLE": "📓 စုံစမ်းစစ်ဆေးရေး ဘုတ်ပြား",
		"NOTEBOOK_SUBTITLE": "သဲလွန်စများကို ချိတ်ဆက်ပြီး သက်သေအထောက်အထားများမှ ကောက်ချက်ချပါ",
		"NOTEBOOK_TAB_CLUES": "🔍 သဲလွန်စများ (%d)",
		"NOTEBOOK_TAB_DEDUCTIONS": "💡 ကောက်ချက်ချမှုများ (%d)",
		"NOTEBOOK_EMPTY": "သဲလွန်စ မရသေးပါ။ နေရာများကို စူးစမ်းပါ၊ လူများနှင့် စကားပြောပါ၊ မသင်္ကာဖွယ်ရာများကို စစ်ဆေးပါ!",
		"NOTEBOOK_COUNT": "တွေ့ရှိသော သဲလွန်စများ - %d",
		"NOTEBOOK_DEDUCTION_COUNT": "ကောက်ချက်ချမှုများ - %d",
		"NOTEBOOK_CLOSE": "✕ ပိတ်မည်",
		"NOTEBOOK_WORKBENCH_TITLE": "🔗 သက်သေအထောက်အထား ပေါင်းစပ်ခုံ",
		"NOTEBOOK_WORKBENCH_HINT": "အထက်ပါ သဲလွန်စ ၂ ခုကို နှိပ်ပြီး ဆက်စပ်မှုကို ပေါင်းစပ်စစ်ဆေးပါ",
		"NOTEBOOK_SLOT_EMPTY": "+ သဲလွန်စရွေးပါ",
		"NOTEBOOK_DEDUCE_BTN": "⚡ ဆက်စပ်ကောက်ချက်ချမည်",
		"NOTEBOOK_CLEAR_BTN": "↺ ရှင်းမည်",
		"NOTEBOOK_DEDUCTIONS_EMPTY": "ကောက်ချက်ချမှု မရှိသေးပါ။\n\nသဲလွန်စများကဏ္ဍတွင် ဆက်စပ်နေသော သဲလွန်စ ၂ ခုကို ရွေးချယ်ပေါင်းစပ်ပါ။",
		"NOTEBOOK_FEEDBACK_SELECT_TWO": "ဆက်စပ်မှုရှာရန် နောက်ထပ် သဲလွန်စတစ်ခု ထပ်မံရွေးချယ်ပါ။",
		"NOTEBOOK_FEEDBACK_NO_MATCH": "ဤသဲလွန်စနှစ်ခု တိုက်ရိုက်မဆက်စပ်သေးပါ။ အချိန်၊ နေရာ သို့မဟုတ် အကြောင်းအရာများကို ပြန်လည်စဉ်းစားပါ။",
		"NOTEBOOK_FEEDBACK_ALREADY": "ဤသဲလွန်စများကို ပေါင်းစပ်ကောက်ချက်ချပြီးဖြစ်သည် - %s",
		"NOTEBOOK_FEEDBACK_SUCCESS": "🎉 ကောက်ချက်အသစ် ဖော်ထုတ်နိုင်ခဲ့သည် - %s!",
		"NOTEBOOK_CONNECTED_LABEL": "ပေါင်းစပ်ထားသော သဲလွန်စများ - ",
		
		# Clue Notice in Dialogue
		"CLUE_RECORDED": "📓 [ သဲလွန်စ မှတ်တမ်းတင်ပြီးပါပြီ - %s ]",
		
		# Inspection Panel
		"INSPECT_PROMPT": "အသေးစိတ်စုံစမ်းရန် အရာဝတ္ထုပေါ်ရှိ မီးမောင်းထိုးထားသော နေရာများကို နှိပ်ပါ။",
		"INSPECT_CLOSE": "✕ ပိတ်မည်",
		"INSPECT_RETURN": "← ဆိုင်ထဲသို့ ပြန်သွားမည်",
		"INSPECT_CLUE_FOUND": "📓 [ သဲလွန်စအသစ် မှတ်တမ်းတင်ပြီး - %s ]",
		"INSPECT_CLUE_ALREADY": "📓 [ မှတ်စုစာအုပ်ထဲ မှတ်တမ်းတင်ပြီးဖြစ်သည် - %s ]",
		"INSPECT_INITIAL_OBS": "အသေးစိတ်ကြည့်ရှုရန် အရာဝတ္ထုပေါ်ရှိ နေရာတစ်ခုခုကို နှိပ်ပါ။",
		"INSPECT_OBS_TITLE": "✦ အသေးစိတ် စစ်ဆေးတွေ့ရှိချက်",
		"INSPECT_NOTEBOOK_BTN": "📓 မှတ်စုစာအုပ် ဖွင့်မည် (%d)",
		
		# Interactive Questioning & Interrogation
		"QUESTIONING_PRESENT_EVIDENCE": "💼 သဲလွန်စ အထောက်အထား တင်ပြမည်...",
		"QUESTIONING_LEAVE": "✕ စကားပြောခြင်း ပြီးဆုံးမည်",
		"QUESTIONING_BACK": "← မေးခွန်းများသို့ ပြန်သွားမည်",
		"QUESTIONING_SELECT_CLUE": "%s ထံ တင်ပြရန် မှတ်စုစာအုပ်ထဲမှ သဲလွန်စတစ်ခုကို ရွေးချယ်ပါ -",
		"QUESTIONING_NO_CLUES": "တင်ပြရန် မှတ်စုစာအုပ်ထဲတွင် သဲလွန်စ မရှိသေးပါ။",
		"QUESTIONING_PROMPT_DEFAULT": "စုံစမ်းစစ်ဆေးမှုအတွက် ဘာများ မေးမြန်းလိုပါသလဲခင်ဗျာ?",
		"QUESTIONING_PROMPT_MORE": "အခြား ဘာများ မေးမြန်းလိုပါသေးသလဲခင်ဗျာ?"
	}
}

const HOTSPOTS: Dictionary = {
	# Inspection Hotspots
	"NotebookHotspot": {
		"en": {
			"button_text": " 🔍 Abandoned Notebook",
			"speaker": "🔍 Inspect: Leather Notebook"
		},
		"my": {
			"button_text": " 🔍 ကျန်ရစ်ခဲ့သော မှတ်စုစာအုပ်",
			"speaker": "🔍 စစ်ဆေးခြင်း - သားရေမှတ်စုစာအုပ်"
		}
	},
	"ReceiptHotspot": {
		"en": {
			"button_text": " 🔍 Crumpled Receipt",
			"speaker": "🔍 Inspect: Tea Order Receipt"
		},
		"my": {
			"button_text": " 🔍 တွန့်ကျေနေသော ဘေလ်ဖြတ်ပိုင်း",
			"speaker": "🔍 စစ်ဆေးခြင်း - ဘေလ်ဖြတ်ပိုင်း"
		}
	},
	"ClockHotspot": {
		"en": {
			"button_text": " 🔍 Antique Wall Clock",
			"speaker": "🔍 Inspect: Teak Wall Clock"
		},
		"my": {
			"button_text": " 🔍 ရှေးဟောင်း နံရံကပ်နာရီ",
			"speaker": "🔍 စစ်ဆေးခြင်း - နံရံကပ်နာရီ"
		}
	},
	# Tea Shop Hotspots
	"TeaMasterHotspot": {
		"en": {
			"button_text": " 💬 Tea Master Ko Zaw",
			"speaker": "✦ Tea Master Ko Zaw",
			"dialogue_default": [
				"Mingalarbar! Welcome to Lucky Tea Shop. Freshly brewed sweet tea is ready on the stove.",
				"The tea shop got crowded earlier and I mixed up the three tea cups on Table Three! Can you help me serve them?",
				"Ask Saya Min, Ma Thida, and Ko Aung about their preferences, then use the Tea Orders Tray on the counter to serve them!"
			],
			"dialogue_solved": [
				"Mingalarbar! Thanks to your keen deduction, Table Three is happily drinking their favorite tea!",
				"That nervous customer dropped the harbor cargo slip when he rushed out. Make sure you check your notebook and investigate the Strand Road docks!"
			]
		},
		"my": {
			"button_text": " 💬 လက်ဖက်ရည်ဆရာ ကိုဇော်",
			"speaker": "✦ လက်ဖက်ရည်ဆရာ ကိုဇော်",
			"dialogue_default": [
				"မင်္ဂလာပါခင်ဗျာ! လပ်ကီးလက်ဖက်ရည်ဆိုင်မှ ကြိုဆိုပါတယ်။ မီးဖိုပေါ်မှာ အသစ်ကျိုထားတဲ့ လက်ဖက်ရည် ချိုချိုမွှေးမွှေး အဆင်သင့်ရှိပါတယ်ခင်ဗျာ။",
				"ခုနက ဆိုင်မှာ လူတွေ အရမ်းကျပ်သွားလို့ စားပွဲအမှတ် (၃) က လက်ဖက်ရည်သုံးခွက် မှားရောကုန်လို့ဗျာ! ကျွန်တော့်ကို ကူပြီး ပို့ပေးနိုင်မလားခင်ဗျာ?",
				"ဆရာမင်း၊ မသီတာနဲ့ ကိုအောင်တို့ဆီက သူတို့သောက်ချင်တဲ့ ပုံစံလေးတွေ မေးမြန်းပြီး ကောင်တာပေါ်က လက်ဖက်ရည်လင်ပန်းကို သုံးပြီး ပို့ပေးပါခင်ဗျာ!"
			],
			"dialogue_solved": [
				"မင်္ဂလာပါ! မင်းရဲ့ ထက်မြက်တဲ့ စုံစမ်းမှုကြောင့် စားပွဲအမှတ် (၃) က ဧည့်သည်တွေ သူတို့ကြိုက်တဲ့ လက်ဖက်ရည်ကို အရသာရှိရှိ သောက်နေကြပါပြီ!",
				"ခုနက ကပျာကယာ ထွက်သွားတဲ့ လူတစ်ယောက် ကမ်းနားလမ်း ဆိပ်ကမ်းကုန်လက်မှတ်ကို ကျပျောက်သွားခဲ့တယ်။ မင်းရဲ့ မှတ်စုစာအုပ်ကို စစ်ဆေးပြီး ကမ်းနားလမ်း ဆိပ်ခံတံတားကို သွားစုံစမ်းပါဦး!"
			]
		}
	},
	"TeaOrdersHotspot": {
		"en": {
			"button_text": "☕ Solve Tea Orders (Table 3)",
			"speaker": "☕ Tea Orders Tray",
			"dialogue_default": ["Interactive order matching tray."]
		},
		"my": {
			"button_text": "☕ လက်ဖက်ရည်အော်ဒါများ ဖြေရှင်းမည် (စားပွဲ ၃)",
			"speaker": "☕ လက်ဖက်ရည်ခွက် လင်ပန်း",
			"dialogue_default": ["လက်ဖက်ရည်အော်ဒါ ပို့ဆောင်ရေး လင်ပန်း။"]
		}
	},
	"MaThidaHotspot": {
		"en": {
			"button_text": " 💬 Ma Thida",
			"speaker": "✦ Ma Thida (The Trader)",
			"dialogue_default": [
				"Phew! What an exhausting day haggling over spice sacks down at Strand Road.",
				"My throat is parched, and I have a huge sweet tooth tonight! Give me the classic balanced sweetness.",
				"Generous condensed milk and rich evaporated milk—a steaming cup of Cho-seint (Sweet & Rich) is perfection!"
			]
		},
		"my": {
			"button_text": " 💬 မသီတာ",
			"speaker": "✦ မသီတာ (ကုန်သည်)",
			"dialogue_default": [
				"ဟူး! ကမ်းနားလမ်းမှာ ဟင်းခတ်အမွှေးအကြိုင်အိတ်တွေ ဈေးဆစ်ရတာ တစ်နေကုန် မောလိုက်တာရှင်။",
				"လည်ချောင်းတွေ ခြောက်ကပ်နေပြီး ဒီညတော့ အချိုလေး သောက်ချင်လိုက်တာ! အချိုနဲ့နို့စိမ့် မျှတတဲ့ အရသာလေး ပေးပါနော်။",
				"နို့ဆီများများနဲ့ နို့စိမ့်ရွှဲရွှဲ—အငွေ့တထောင်းထောင်းနဲ့ ချိုစိမ့်လက်ဖက်ရည်တစ်ခွက်က အကောင်းဆုံးပဲ!"
			]
		}
	},
	"SayaMinHotspot": {
		"en": {
			"button_text": " 💬 Saya Min",
			"speaker": "✦ Saya Min (The Teacher)",
			"dialogue_default": [
				"Mingalarbar! Ah, my eyes are heavy from grading examination papers all evening.",
				"In a Yangon tea shop, you must know your brew! I need something bold and extra strong to fuel my mind through the midnight hours.",
				"A heavy dose of dark Assam tea leaves with a sweet kick—Cho-pyit (Sweet & Strong) is the only drink that will keep me awake!"
			]
		},
		"my": {
			"button_text": " 💬 ဆရာမင်း",
			"speaker": "✦ ဆရာမင်း (ကျောင်းဆရာ)",
			"dialogue_default": [
				"မင်္ဂလာပါ! တစ်ညနေလုံး စာမေးပွဲအဖြေလွှာတွေ စစ်နေရလို့ မျက်လုံးတွေတောင် ညောင်းနေပြီကွယ်။",
				"ရန်ကုန်လက်ဖက်ရည်ဆိုင်မှာ လက်ဖက်ရည်ပုံစံကို သိဖို့လိုတယ်ကွယ့်! သန်းခေါင်ယံအထိ စာဆက်စစ်နိုင်ဖို့ အဆီအပြစ် ပြင်းပြင်းလေး သောက်မှ ဖြစ်မယ်။",
				"လက်ဖက်ရည်နက် အပြစ်အရသာနဲ့ အချိုလေးပါတွဲစပ်ထားတဲ့ ချိုပြစ်တစ်ခွက်ကသာ ငါ့ကို မျက်စိပွင့်စေမှာ!"
			]
		}
	},
	"KoAungHotspot": {
		"en": {
			"button_text": " 💬 Ko Aung",
			"speaker": "✦ Ko Aung (The Driver)",
			"dialogue_default": [
				"Rainy night taxi shifts are tough work. Navigating colonial potholes around Sule Pagoda takes sharp focus.",
				"My doctor told me to cut way back on the sugar, but I can't resist the rich evaporated milk froth.",
				"Keep the sugar low but make it extra creamy—a proper cup of Pawt-seint (Mild & Creamy) will keep me driving smooth!"
			]
		},
		"my": {
			"button_text": " 💬 ကိုအောင်",
			"speaker": "✦ ကိုအောင် (အငှားယာဉ်မောင်း)",
			"dialogue_default": [
				"မိုးရွာတဲ့ည အငှားယာဉ်မောင်းရတာ မလွယ်လှဘူးဗျာ။ ဆူးလေဘုရားပတ်ချာလည်က ချိုင့်ခွက်တွေကို သတိထားပြီး မောင်းနေရတယ်။",
				"ဆရာဝန်က သကြားလျှော့စားဖို့ သတိပေးထားပေမယ့် နို့စိမ့်အမြှုပ်လေးရဲ့ အရသာကိုတော့ မလွန်ဆန်နိုင်ဘူးဗျာ။",
				"အချိုလျှော့ပြီး နို့စိမ့်လေး မွှေးနေအောင် လုပ်ပေးပါ—ပေါ့စိမ့်လက်ဖက်ရည်တစ်ခွက်က ညလုံးပေါက် မောင်းဖို့ အသင့်တော်ဆုံးပဲဗျ!"
			]
		}
	},
	"KettleHotspot": {
		"en": {
			"button_text": " 🔍 Steaming Kettle",
			"speaker": "🔍 Inspect: Brass Kettle",
			"dialogue_default": [
				"A heavy brass kettle hisses gently over a small gas flame, releasing the rich fragrance of boiling Assam tea leaves.",
				"Behind the kettle, you spot a folded newspaper with an article circled in red ink: 'Mysterious Night Cargo Unloaded at Yangon Port'."
			]
		},
		"my": {
			"button_text": " 🔍 ရေနွေးနွေးကြိုအိုး",
			"speaker": "🔍 စစ်ဆေးခြင်း - ကြေးရေနွေးကရား",
			"dialogue_default": [
				"မီးဖိုပေါ်တွင် အငွေ့တထောင်းထောင်းထနေသော ကြေးရေနွေးကရားမှ ကျိုချက်ထားသော လက်ဖက်ရည်ကြမ်းနံ့ သင်းပျံ့နေသည်။",
				"ရေနွေးကရားနောက်ဘက်တွင် အနီရောင်မှင်ဖြင့် ဝိုင်းထားသော သတင်းစာဟောင်းတစ်စောင်ကို တွေ့ရသည် - 'ရန်ကုန်ဆိပ်ကမ်းတွင် သန်းခေါင်ယံ လျှို့ဝှက်ကုန်စည် ချထားသည်'။"
			]
		}
	},
	"TableHotspot": {
		"en": {
			"button_text": " 🔍 Table Three",
			"speaker": "🔍 Inspect: Table Three",
			"dialogue_default": [
				"A low round wooden table surrounded by green plastic stools. Three empty glass mugs sit on saucers awaiting the correct brew.",
				"Saya Min's exam papers, Ma Thida's ledger bag, and Ko Aung's car keys are scattered neatly on the tabletop."
			]
		},
		"my": {
			"button_text": " 🔍 စားပွဲအမှတ် (၃)",
			"speaker": "🔍 စစ်ဆေးခြင်း - စားပွဲအမှတ် (၃)",
			"dialogue_default": [
				"အစိမ်းရောင် ပလတ်စတစ်ခုံနိမ့်လေးများ ဝန်းရံထားသော သစ်သားဝိုင်းစားပွဲလေးဖြစ်သည်။ အော်ဒါမှန်ကန်သော လက်ဖက်ရည်ခွက်များကို စောင့်မျှော်နေကြသည်။",
				"ဆရာမင်း၏ စာမေးပွဲအဖြေလွှာများ၊ မသီတာ၏ စာရင်းအိတ်နှင့် ကိုအောင်၏ ကားသော့များသည် စားပွဲပေါ်တွင် အသီးသီး ရှိနေကြသည်။"
			]
		}
	},
	
	# Market Hotspots
	"VendorHotspot": {
		"en": {
			"button_text": " 💬 Food Vendor Ko Lin",
			"speaker": "✦ Ko Lin (Food Vendor)",
			"dialogue_default": [
				"Hot grilled pork skewers and sweet tea! Best midnight snack in Yangon!",
				"Wait, detective... I am in terrible trouble! My grandfather's secret recipe and delivery ledger notebook was locked inside my iron spice chest by the pier, but the three-dial lock is jammed!",
				"Can you inspect the fruit stand and riverboat crates to help me align the lock dials and recover my notebook?"
			],
			"dialogue_solved": [
				"Thank you so much, detective! You unlocked the chest and saved my grandfather's notebook!",
				"Look at this secret delivery entry: someone ordered a clandestine cargo delivery to the Downtown Heritage Vault tonight under Passcode 1886! Go speak with Night Watchman U Ba right away!"
			]
		},
		"my": {
			"button_text": " 💬 အစားအစာရောင်းသူ ကိုလင်း",
			"speaker": "✦ ကိုလင်း (အစားအစာရောင်းသူ)",
			"dialogue_default": [
				"ဝက်သားကင် ပူပူနွေးနွေးနဲ့ လက်ဖက်ရည်ချိုချို ရမယ်နော်! ရန်ကုန်ညရဲ့ အကောင်းဆုံး အဆာပြေစာပါခင်ဗျာ!",
				"နေပါဦး စုံထောက်ကြီးရယ်... ကျွန်တော် ဒုက္ခရောက်နေလို့ပါ! ကျွန်တော့်အဘိုးရဲ့ လျှို့ဝှက်ချက်နည်းနဲ့ ကုန်စည်ပို့ဆောင်ရေး မှတ်စုစာအုပ်ကို ဆိပ်ခံဘက်က သံသေတ္တာထဲ ထည့်ထားတာ သော့ချိတ်သုံးခုက ဂျမ်းဖြစ်နေလို့ဗျာ!",
				"သစ်သီးဆိုင်နဲ့ ကုန်တင်လှေပေါ်က သေတ္တာတွေကို စစ်ဆေးပြီး ကျွန်တော့်မှတ်စုစာအုပ် ပြန်ရအောင် သော့ဖွင့်ပေးနိုင်မလားခင်ဗျာ?"
			],
			"dialogue_solved": [
				"ကျေးဇူးအရမ်းတင်ပါတယ် စုံထောက်ကြီးခင်ဗျာ! သေတ္တာသော့ကို ဖွင့်ပေးပြီး အဘိုးရဲ့ မှတ်စုစာအုပ်ကို ကယ်တင်ပေးနိုင်ခဲ့ပါပြီ!",
				"ဒီမှာကြည့်ပါဦး! လျှို့ဝှက်ကုဒ် ၁၈၈၆ နဲ့ ဒီည မြို့လယ်ရှေးဟောင်းတိုက်ကို ကုန်စည်ပို့ဖို့ ရေးထားတယ်ဗျ! ညစောင့် ဦးဘဆီ ချက်ချင်း သွားပြောလိုက်ပါတော့!"
			]
		}
	},
	"MarketNotebookHotspot": {
		"en": {
			"button_text": "📦 Locked Spice Chest (Notebook)",
			"speaker": "🔍 Inspect: Iron Spice Chest",
			"dialogue_default": ["A heavy iron spice chest with three combination dials holding Ko Lin's missing notebook."]
		},
		"my": {
			"button_text": "📦 သော့ခတ်ထားသော ဟင်းခတ်သေတ္တာ (မှတ်စုစာအုပ်)",
			"speaker": "🔍 စစ်ဆေးခြင်း - သံဟင်းခတ်သေတ္တာ",
			"dialogue_default": ["ကိုလင်း၏ ပျောက်ဆုံးမှတ်စုစာအုပ် ပါရှိသော သော့ခလုတ်သုံးခုပါ သံသေတ္တာလေး။"]
		}
	},
	"PierHotspot": {
		"en": {
			"button_text": " 🔍 Cargo Boat",
			"speaker": "🔍 Inspect: River Cargo Boat",
			"dialogue_default": [
				"A weathered wooden riverboat sways against the stone quay under the moonlight.",
				"Several wooden crates with fresh port stamps are stacked on deck. One crate is marked: 'Storage Bay: Pier 4 Riverboat Cargo Stash'."
			]
		},
		"my": {
			"button_text": " 🔍 ကုန်တင်လှေ",
			"speaker": "🔍 စစ်ဆေးခြင်း - ကုန်တင်လှေ",
			"dialogue_default": [
				"လရောင်အောက်တွင် ကျောက်ဆိပ်ခံတံတားဘေး လှိုင်းခတ်နေသော သစ်သားကုန်တင်လှေတစ်စင်း။",
				"ဆိပ်ကမ်းတံဆိပ်တုံး ရိုက်နှိပ်ထားသော သစ်သားသေတ္တာများ ကုန်းပတ်ပေါ်တွင် စီထားသည်။ သေတ္တာတစ်ခုတွင် 'အမှတ် (၄) ဆိပ်ခံတံတား ကုန်သိုလှောင်ရာ' ဟု တံဆိပ်တုံးထုထားသည်။"
			]
		}
	},
	"FruitBasketHotspot": {
		"en": {
			"button_text": " 🔍 Fruit Stand",
			"speaker": "🔍 Inspect: Fruit Stand",
			"dialogue_default": [
				"Baskets overflowing with fresh pomelos, mangosteens, and bananas under yellow tarps.",
				"Tucked between two baskets of limes, you spot an antique brass coin bearing an old Burmese royal peacock seal!"
			]
		},
		"my": {
			"button_text": " 🔍 သစ်သီးဆိုင်",
			"speaker": "🔍 စစ်ဆေးခြင်း - သစ်သီးဆိုင်",
			"dialogue_default": [
				"ဝါကျင့်ကျင့်မိုးကာတဲအောက်တွင် ကျွဲကောသီး၊ မင်းကွတ်သီးနှင့် ငှက်ပျောသီးများ ပြည့်လျှံနေသော ဝါးခြင်းတောင်းများ။",
				"သံပရာသီးခြင်းကြားတွင် ရှေးဟောင်းမြန်မာတော်ဝင် ဒေါင်းတံဆိပ်တော်ပါသော ကြေးဒင်္ဂါးပြားဟောင်းတစ်ခုကို တွေ့ရသည်!"
			]
		}
	},
	
	# Downtown Hotspots
	"WatchmanHotspot": {
		"en": {
			"button_text": " 💬 Night Watchman U Ba",
			"speaker": "✦ Night Watchman U Ba",
			"dialogue_default": [
				"Hold on there, friend! Walking downtown in the rain so late?",
				"I keep watch over these old colonial banks and heritage halls. Nothing escapes my eyes.",
				"Though if you're looking for that hurried fellow with the briefcase, he darted toward the tea shops on 38th Street!"
			],
			"dialogue_market_solved": [
				"Hold on there! You carry Ko Lin's recovered delivery ledger and the harbor cargo manifest?",
				"The Heritage Vault Gate right behind me is waiting for the verified delivery credentials. Inspect the gate console to complete the dispatch!"
			],
			"dialogue_delivery_solved": [
				"Outstanding work, detective! The antique lacquer lockbox is verified and secured in the Heritage Vault.",
				"You've safeguarded Yangon's historic treasures tonight! You can review the case resolution at the vault gate whenever you wish."
			]
		},
		"my": {
			"button_text": " 💬 ညစောင့် ဦးဘ",
			"speaker": "✦ ညစောင့် ဦးဘ",
			"dialogue_default": [
				"နေပါဦး မိတ်ဆွေ! ဒီလောက် မိုးချုပ်ကြီး မိုးထဲရေထဲ လမ်းလျှောက်နေတာ ဘာကိစ္စများ ရှိလို့လဲ?",
				"ငါက ဒီရှေးဟောင်းကိုလိုနီဘဏ်တိုက်တွေနဲ့ အမွေအနှစ်အဆောက်အအုံတွေကို စောင့်ရှောက်နေတာ။ ငါ့မျက်စိအောက်က ဘာမှ မလွတ်စေရဘူး။",
				"လက်ဆွဲအိတ်နဲ့ အလောတကြီး ပြေးသွားတဲ့လူကို ရှာနေတာဆိုရင်တော့ သူ ၃၈ လမ်း လက်ဖက်ရည်ဆိုင်ဘက်ကို ပြေးသွားတယ်ကွယ့်!"
			],
			"dialogue_market_solved": [
				"နေပါဦးကွဲ့! မင်းဆီမှာ ကိုလင်းရဲ့ ပို့ဆောင်ရေးမှတ်စုစာအုပ်နဲ့ ဆိပ်ကမ်းကုန်စာရင်း ပါလာတယ်ဟုတ်လား?",
				"ငါ့နောက်က ရှေးဟောင်းတိုက်တံခါးကြီးက အတည်ပြုကုန်စည်အထောက်အထားကို စောင့်နေတာ။ တံခါးခလုတ်ခုံကို စစ်ဆေးပြီး ပို့ဆောင်မှုကို ပြီးမြောက်အောင် လုပ်လိုက်ပါ!"
			],
			"dialogue_delivery_solved": [
				"အရမ်းတော်တယ် စုံထောက်ကြီး! ရှေးဟောင်းသစ်စေးယွန်းသေတ္တာကြီးကို စစ်ဆေးပြီး အမွေအနှစ်တိုက်ထဲမှာ ဘေးကင်းစွာ ထိန်းသိမ်းလိုက်ပါပြီ။",
				"ဒီည ရန်ကုန်ရဲ့ သမိုင်းဝင်အမွေအနှစ်တွေကို ကာကွယ်ပေးနိုင်ခဲ့ပြီကွယ်! အမှုပြီးဆုံးမှုမှတ်တမ်းကို တံခါးခလုတ်ခုံမှာ အချိန်မရွေး ပြန်ကြည့်နိုင်ပါတယ်!"
			]
		}
	},
	"DeliveryHotspot": {
		"en": {
			"button_text": "🏛️ Heritage Vault Gate (Delivery)",
			"speaker": "🔍 Inspect: Heritage Vault Gate",
			"dialogue_default": ["Colonial vault security gate dispatch console."]
		},
		"my": {
			"button_text": "🏛️ ရှေးဟောင်းတိုက်တံခါး (ကုန်စည်ပို့ဆောင်မှု)",
			"speaker": "🔍 စစ်ဆေးခြင်း - ရှေးဟောင်းတိုက်တံခါး",
			"dialogue_default": ["ကိုလိုနီခေတ် ရှေးဟောင်းတိုက်တံခါး ကုန်စည်ပို့ဆောင်ရေး ခလုတ်ခုံ။"]
		}
	},
	"NoticeBoardHotspot": {
		"en": {
			"button_text": " 🔍 Notice Board",
			"speaker": "🔍 Inspect: Colonial Notice Board",
			"dialogue_default": [
				"A weathered teak bulletin board affixed to the entrance of a heritage building.",
				"A freshly pinned scrap of paper catches your eye: 'Midnight rendezvous confirmed at Strand Road cargo pier.'"
			]
		},
		"my": {
			"button_text": " 🔍 ကြော်ငြာသင်ပုန်း",
			"speaker": "🔍 စစ်ဆေးခြင်း - ကြော်ငြာသင်ပုန်း",
			"dialogue_default": [
				"ရှေးဟောင်းအဆောက်အအုံ အဝင်ဝတွင် တပ်ဆင်ထားသော သစ်သားကြော်ငြာသင်ပုန်းဟောင်း။",
				"အသစ်ကပ်ထားသော စာရွက်အပိုင်းအစတစ်ခုကို တွေ့ရသည် - 'ကမ်းနားလမ်း ကုန်တင်ဆိပ်ခံတွင် သန်းခေါင်ယံတွေ့ဆုံမှု အတည်ပြုသည်'။"
			]
		}
	},
	"StreetlampHotspot": {
		"en": {
			"button_text": " 🔍 Streetlamp",
			"speaker": "🔍 Inspect: Streetlamp & Puddle",
			"dialogue_default": [
				"An ornate cast-iron streetlamp casts a warm pool of golden light onto wet cobblestones.",
				"In the ripple of the puddle, you spot bicycle tire tracks heading south toward the river docks."
			]
		},
		"my": {
			"button_text": " 🔍 လမ်းမီးတိုင်",
			"speaker": "🔍 စစ်ဆေးခြင်း - လမ်းမီးတိုင်နှင့် ရေအိုင်",
			"dialogue_default": [
				"ရှေးဟောင်းသံလမ်းမီးတိုင်မှ ရွှေဝါရောင်မီးရောင်သည် စိုစွတ်သော လမ်းခင်းကျောက်ပြားများပေါ်သို့ ထင်ဟပ်နေသည်။",
				"ရေအိုင်လှိုင်းထမှုကြားတွင် တောင်ဘက်မြစ်ဆိပ်ကမ်းသို့ ဦးတည်သွားသော စက်ဘီးဘီးရာများကို တွေ့ရသည်။"
			]
		}
	}
}

const CLUES: Dictionary = {
	"tea_port_newspaper": {
		"icon": "📰",
		"en": {
			"title": "Circled Port Cargo Article",
			"description": "A yesterday newspaper article tucked behind the tea kettle with a red ink circle around 'Mysterious Night Cargo Unloaded at Yangon Port'.",
			"location": "Lucky Tea Shop"
		},
		"my": {
			"title": "အနီရောင်ဝိုင်းထားသော ဆိပ်ကမ်းကုန်စည်သတင်း",
			"description": "လက်ဖက်ရည်အိုးနောက်တွင် တွေ့ရသော 'ရန်ကုန်ဆိပ်ကမ်းတွင် သန်းခေါင်ယံ လျှို့ဝှက်ကုန်စည် ချထားသည်' ဟူသော သတင်းစာဟောင်းဖြတ်ပိုင်း။",
			"location": "လပ်ကီးလက်ဖက်ရည်ဆိုင်"
		}
	},
	"tea_notebook_cipher": {
		"icon": "📜",
		"en": {
			"title": "Cipher in the Left-Behind Notebook",
			"description": "A handwritten cipher in the leather notebook: 'Deliver parcel to Pier 4 before midnight whistle. Watch the shadows.'",
			"location": "Lucky Tea Shop"
		},
		"my": {
			"title": "မှတ်စုစာအုပ်ပါ လျှို့ဝှက်ကုဒ်",
			"description": "သားရေမှတ်စုထဲတွင် 'သန်းခေါင်ယံ ဥဩမဆွဲမီ အထုပ်ကို ဆိပ်ခံတံတား (၄) သို့ ပို့ပါ။ အရိပ်တွေကို သတိထားပါ' ဟု ရေးထားသည်။",
			"location": "လပ်ကီးလက်ဖက်ရည်ဆိုင်"
		}
	},
	"tea_receipt_timestamp": {
		"icon": "🧾",
		"en": {
			"title": "Late-Night Order Timestamp",
			"description": "The tea shop cash register stamped 11:42 PM on Table 3's bill, mere minutes before the commotion.",
			"location": "Lucky Tea Shop"
		},
		"my": {
			"title": "ညဉ့်နက် လက်ဖက်ရည်ဆိုင် ဘေလ်အချိန်",
			"description": "စားပွဲ (၃) ဘေလ်ပေါ်တွင် ၁၁:၄၂ ဟု အချိန်တံဆိပ်ရိုက်နှိပ်ထားသည်—ရုတ်ရုတ်သဲသဲ မဖြစ်မီ မိနစ်ပိုင်းအလို။",
			"location": "လပ်ကီးလက်ဖက်ရည်ဆိုင်"
		}
	},
	"tea_clock_stopped_time": {
		"icon": "🕒",
		"en": {
			"title": "Stopped Clock at 11:45 PM",
			"description": "The antique wall clock hands stopped abruptly at 11:45 PM, exactly when the mysterious figure fled.",
			"location": "Lucky Tea Shop"
		},
		"my": {
			"title": "၁၁:၄၅ တွင် ရပ်တန့်နေသော နံရံကပ်နာရီ",
			"description": "လျှို့ဝှက်လူ ထွက်ပြေးသွားချိန်ဖြစ်သော ညဉ့်နက် ၁၁:၄၅ အတိတွင် ရှေးဟောင်းနံရံကပ်နာရီ ရပ်တန့်သွားခဲ့သည်။",
			"location": "လပ်ကီးလက်ဖက်ရည်ဆိုင်"
		}
	},
	"harbor_cargo_slip": {
		"icon": "⚓",
		"en": {
			"title": "Stained Harbor Cargo Slip",
			"description": "A rain-soaked delivery receipt dropped at the tea shop: 'Pier 4 - Midnight Unloading - Container #7 with Royal Hintha Seal'.",
			"location": "Lucky Tea Shop"
		},
		"my": {
			"title": "ဆိပ်ကမ်းကုန်စည်လက်မှတ်ဟောင်း",
			"description": "လက်ဖက်ရည်ဆိုင်တွင် ကျပျောက်ခဲ့သော 'ဆိပ်ခံ ၄ - သန်းခေါင်ယံကုန်ချ - ဟင်္သာတံဆိပ်ပါ သေတ္တာ #၇' ဟူသော ကုန်လက်မှတ်။",
			"location": "လပ်ကီးလက်ဖက်ရည်ဆိုင်"
		}
	},
	"market_cargo_crates": {
		"icon": "📦",
		"en": {
			"title": "Wax-Sealed Riverboat Crates",
			"description": "Wooden crates stacked on the moored riverboat stamped 'Pier 4 Riverboat Cargo Stash'.",
			"location": "Night Market"
		},
		"my": {
			"title": "ဖယောင်းတံဆိပ်ခတ် ကုန်တင်လှေသေတ္တာများ",
			"description": "ကုန်တင်လှေပေါ်တွင် စီထားသော 'အမှတ် (၄) ဆိပ်ခံတံတား ကုန်သိုလှောင်ရာ' ဟု အမှတ်အသားပါသော သစ်သားသေတ္တာများ။",
			"location": "ညဈေးတန်း"
		}
	},
	"market_peacock_coin": {
		"icon": "🪙",
		"en": {
			"title": "Antique Peacock Brass Coin",
			"description": "An antique brass coin bearing an embossed royal Burmese peacock seal, dropped between lime baskets.",
			"location": "Night Market"
		},
		"my": {
			"title": "ရှေးဟောင်းဒေါင်းတံဆိပ် ကြေးဒင်္ဂါးပြား",
			"description": "သံပရာသီးခြင်းကြားတွင် တွေ့ရှိရသော တော်ဝင်ဒေါင်းတံဆိပ် ရိုက်နှိပ်ထားသည့် ရှေးဟောင်းကြေးဒင်္ဂါးပြား။",
			"location": "ညဈေးတန်း"
		}
	},
	"vendor_delivery_ledger": {
		"icon": "📔",
		"en": {
			"title": "Vendor's Midnight Delivery Ledger",
			"description": "Ko Lin's recovered notebook contains the midnight delivery dispatch: Consignment #4 must be delivered to Heritage Vault Keeper U Ba at Downtown Sule using Secret Passcode 1886.",
			"location": "Night Market"
		},
		"my": {
			"title": "ဈေးသည်၏ သန်းခေါင်ယံ ကုန်စည်စာရင်း",
			"description": "ကိုလင်း၏ မှတ်စုစာအုပ်ပါ အချက်အလက် - 'အမှတ် ၄ ကုန်စည်ကို မြို့လယ်ဆူးလေ ရှေးဟောင်းတိုက်စောင့် ဦးဘထံသို့ လျှို့ဝှက်ကုဒ် ၁၈၈၆ ဖြင့် ပို့ဆောင်ရမည်'။",
			"location": "ညဈေးတန်း"
		}
	},
	"downtown_pier_note": {
		"icon": "✉️",
		"en": {
			"title": "Midnight Pier Rendezvous Note",
			"description": "A handwritten scrap of paper pinned to the colonial bulletin board: 'Midnight rendezvous confirmed at Strand Road cargo pier.'",
			"location": "Downtown (Sule)"
		},
		"my": {
			"title": "သန်းခေါင်ယံ ဆိပ်ကမ်းတွေ့ဆုံမှုမှတ်စု",
			"description": "ကြော်ငြာသင်ပုန်းတွင် တွေ့ရသော 'ကမ်းနားလမ်း ကုန်တင်ဆိပ်ခံတွင် သန်းခေါင်ယံတွေ့ဆုံမှု အတည်ပြုသည်' ဟူသော လက်ရေးစာရွက်။",
			"location": "မြို့လယ် (ဆူးလေ)"
		}
	},
	"downtown_tire_tracks": {
		"icon": "🚲",
		"en": {
			"title": "Waterfront Tire Tracks",
			"description": "Fresh bicycle tire tracks visible under the streetlamp puddle leading south toward the river docks.",
			"location": "Downtown (Sule)"
		},
		"my": {
			"title": "ကမ်းနားလမ်း ဘီးရာများ",
			"description": "လမ်းမီးတိုင်အောက် ရေအိုင်ထဲတွင် မြစ်ဆိပ်ကမ်းဘက်သို့ ဦးတည်သွားသော လတ်ဆတ်သည့် စက်ဘီးဘီးရာများ။",
			"location": "မြို့လယ် (ဆူးလေ)"
		}
	},
	"heritage_vault_secured": {
		"icon": "🏛️",
		"en": {
			"title": "Heritage Vault Secured & Relics Restored",
			"description": "The midnight cargo of stolen 19th-century colonial brass relics and royal lacquered manuscripts has been safely secured in the Downtown vault!",
			"location": "Downtown (Sule)"
		},
		"my": {
			"title": "ရှေးဟောင်းတိုက်လုံခြုံပြီး အမွေအနှစ်များ ပြန်လည်ထိန်းသိမ်းနိုင်ခဲ့ခြင်း",
			"description": "ခိုးယူခံရသော ၁၉ ရာစု ရှေးဟောင်းကြေးထည်များနှင့် တော်ဝင်သစ်စေးယွန်းပေစာများကို မြို့လယ်တိုက်ခန်းထဲတွင် အောင်မြင်စွာ ထိန်းသိမ်းနိုင်ခဲ့ပြီ!",
			"location": "မြို့လယ် (ဆူးလေ)"
		}
	}
}

const DEDUCTIONS: Dictionary = {
	"deduction_tea_three_minutes": {
		"clues": ["tea_receipt_timestamp", "tea_clock_stopped_time"],
		"icon": "⏱️",
		"en": {
			"title": "The Three-Minute Rush",
			"description": "Table 3's receipt was stamped at 11:42 PM, and the antique wall clock jammed at 11:45 PM. The entire incident occurred in a frantic 3-minute window—the suspect fled immediately after paying!",
			"summary": "Suspect paid at 11:42 PM and fled at 11:45 PM."
		},
		"my": {
			"title": "သုံးမိနစ်ကြာ အလျင်စလိုဖြစ်စဉ်",
			"description": "စားပွဲ (၃) ၏ ဘေလ်ရှင်းချိန်သည် ၁၁:၄၂ ဖြစ်ပြီး နံရံကပ်နာရီသည် ၁၁:၄၅ တွင် ရပ်တန့်သွားသည်။ ဖြစ်စဉ်တစ်ခုလုံးသည် အလျင်စလို ၃ မိနစ်အတွင်း ဖြစ်ပွားခဲ့ခြင်းဖြစ်သည်—ငွေရှင်းပြီးသည်နှင့် သံသယရှိသူ ချက်ချင်းပြေးထွက်သွားခဲ့သည်!",
			"summary": "သံသယရှိသူသည် ၁၁:၄၂ တွင် ငွေရှင်းပြီး ၁၁:၄၅ တွင် ပြေးထွက်သွားခဲ့သည်။"
		}
	},
	"deduction_tea_pier_rendezvous": {
		"clues": ["tea_notebook_cipher", "harbor_cargo_slip"],
		"icon": "⚓",
		"en": {
			"title": "Midnight Rendezvous at Pier 4",
			"description": "The cipher left in the abandoned notebook ordered a delivery to Pier 4 before the midnight whistle, matching the harbor cargo slip for Container #7. The fugitive is heading to Pier 4 on the riverfront!",
			"summary": "Fugitive and midnight cargo are converging on Pier 4."
		},
		"my": {
			"title": "ဆိပ်ခံ (၄) သန်းခေါင်ယံ တွေ့ဆုံမှု",
			"description": "ကျန်ရစ်ခဲ့သော သားရေမှတ်စုပါ လျှို့ဝှက်ကုဒ်တွင် သန်းခေါင်ယံမတိုင်မီ ဆိပ်ခံ (၄) သို့ အထုပ်ပို့ရန် ညွှန်ကြားထားပြီး ဆိပ်ကမ်းကုန်လက်မှတ်ပါ သေတ္တာ #၇ နှင့် ကိုက်ညီနေသည်။ ထွက်ပြေးသူသည် မြစ်ကမ်းနား ဆိပ်ခံ (၄) သို့ ဦးတည်သွားနေသည်!",
			"summary": "ထွက်ပြေးသူနှင့် သန်းခေါင်ယံကုန်စည်တို့သည် ဆိပ်ခံ (၄) တွင် တွေ့ဆုံမည်ဖြစ်သည်။"
		}
	},
	"deduction_tea_smuggling_ring": {
		"clues": ["tea_port_newspaper", "harbor_cargo_slip"],
		"icon": "🕵️",
		"en": {
			"title": "Covert Midnight Smuggling Ring",
			"description": "The circled port newspaper article about suspicious late-night cargo aligns with the stained slip bearing the Royal Hintha Seal. This incident is tied to an organized midnight smuggling network operating on Strand Road!",
			"summary": "An organized smuggling syndicate is moving relics through Yangon port."
		},
		"my": {
			"title": "လျှို့ဝှက်ဆိပ်ကမ်း ကုန်မှောင်ခိုလှုပ်ရှားမှု",
			"description": "သတင်းစာတွင် ဝိုင်းထားသော ဆိပ်ကမ်းကုန်စည်သတင်းသည် တော်ဝင်ဟင်္သာတံဆိပ်ပါ ကုန်လက်မှတ်နှင့် တိုက်ရိုက်ဆက်စပ်နေသည်။ ဤသည်မှာ သာမန်ခိုးမှုမဟုတ်ဘဲ ကမ်းနားလမ်းတွင် လှုပ်ရှားနေသော စနစ်တကျ ကုန်မှောင်ခိုဂိုဏ်းတစ်ခု ဖြစ်သည်!",
			"summary": "စနစ်တကျ ဖွဲ့စည်းထားသော မှောင်ခိုဂိုဏ်းတစ်ခုသည် ရန်ကုန်ဆိပ်ကမ်းမှတစ်ဆင့် ရှေးဟောင်းပစ္စည်းများ သယ်ယူနေသည်။"
		}
	}
}

const TEA_PUZZLE: Dictionary = {
	"en": {
		"title": "☕ TEA SHOP ORDER PUZZLE",
		"subtitle": "Match each customer at Table 3 to their requested Burmese tea brew",
		"status_unsolved": "STATUS: UNSOLVED 🔒",
		"status_solved": "STATUS: SOLVED ✔",
		"serve_btn": "Serve Orders ☕",
		"served_btn": "Orders Served ✔",
		"prompt": "Serve this Tea:",
		"choices": [
			"-- Select a Tea Order --",
			"Cho-seint (Sweet & Rich)",
			"Cho-pyit (Sweet & Strong)",
			"Pawt-seint (Mild & Creamy)"
		],
		"hints": {
			"min": "\"Grading papers all night. Needs a bold, dark brew with an extra strong caffeine kick to stay awake.\"",
			"thida": "\"Parched throat from trading. Craves classic rich sweetness and generous creamy condensed milk.\"",
			"aung": "\"Night shift driver. Strictly low sugar to avoid the jitters, but wants extra rich evaporated milk.\""
		},
		"customer_names": {
			"min": "Saya Min (Teacher)",
			"thida": "Ma Thida (Trader)",
			"aung": "Ko Aung (Taxi Driver)"
		},
		"feedback_init": "Examine customer dialogues for clues on sweetness and strength, select their requested tea brews, and press Serve Orders.",
		"feedback_incomplete": "⚠️ You haven't chosen a tea order for all three customers yet! Select an order for each person before serving.",
		"feedback_solved": "🎉 Spot on! Every customer is happily sipping their favorite brew!\nTea Master Ko Zaw nods in approval and hands you a dropped harbor cargo slip!",
		"feedback_solved_summary": "All customers received their favorite tea orders! The harbor cargo slip has been recorded in your notebook.",
		"feedback_0": "❌ None of the tea cups match what the customers asked for!\nHint: Check who needs strong caffeine to stay awake, who wants classic sweetness, and who asked for low sugar.",
		"feedback_1": "❌ Only 1 of the 3 orders is correct! Some customers are shaking their heads.\nHint: Saya Min needs heavy caffeine (Cho-pyit), while Ko Aung wants low sugar (Pawt-seint).",
		"feedback_2": "❌ So close! 2 of the 3 orders are correct, but 1 customer got the wrong cup.\nDouble-check the difference between Cho-seint (Sweet & Rich) and Cho-pyit (Sweet & Strong)."
	},
	"my": {
		"title": "☕ လပ်ကီးလက်ဖက်ရည်ဆိုင် အော်ဒါပဟေဠိ",
		"subtitle": "စားပွဲ (၃) မှ ဧည့်သည်တစ်ဦးချင်းစီ၏ အကြိုက်ဆုံး လက်ဖက်ရည်ကို တွဲစပ်ပေးပါ",
		"status_unsolved": "အခြေအနေ - မပြီးသေးပါ 🔒",
		"status_solved": "အခြေအနေ - ပြီးမြောက်ပါပြီ ✔",
		"serve_btn": "လက်ဖက်ရည်ပို့မည် ☕",
		"served_btn": "လက်ဖက်ရည်ပို့ပြီးပါပြီ ✔",
		"prompt": "ဤလက်ဖက်ရည် ပို့မည် -",
		"choices": [
			"-- လက်ဖက်ရည်ရွေးချယ်ပါ --",
			"ချိုစိမ့် (အချိုနှင့် နို့စိမ့်)",
			"ချိုပြစ် (အချိုနှင့် လက်ဖက်ရည်အပြစ်)",
			"ပေါ့စိမ့် (အချိုပေါ့ပြီး နို့စိမ့်)"
		],
		"hints": {
			"min": "\"တစ်ညလုံး စာမေးပွဲစစ်ရမည်။ မျက်စိပွင့်လန်းစေရန် လက်ဖက်ရည်နက် အဆီအပြစ် ပြင်းပြင်းလေး လိုအပ်သည်။\"",
			"thida": "\"ဈေးရောင်းရ၍ မောပန်းနေသည်။ ဂန္ထဝင်အချိုစိမ့်အရသာနှင့် နို့ဆီရွှဲရွှဲလေး သောက်လိုသည်။\"",
			"aung": "\"ညဆိုင်း တက္ကစီမောင်းရမည်။ သကြားကို တင်းကြပ်စွာ လျှော့သော်လည်း နို့စိမ့်အမြှုပ်လေး မွှေးနေအောင် သောက်လိုသည်။\""
		},
		"customer_names": {
			"min": "ဆရာမင်း (ကျောင်းဆရာ)",
			"thida": "မသီတာ (ကုန်သည်)",
			"aung": "ကိုအောင် (အငှားယာဉ်မောင်း)"
		},
		"feedback_init": "ဧည့်သည်များ၏ စကားပြောသဲလွန်စများကို ဖတ်ရှုပြီး သူတို့သောက်လိုသော လက်ဖက်ရည်ကို ရွေးချယ်ကာ ပို့ဆောင်ပါခင်ဗျာ။",
		"feedback_incomplete": "⚠️ ဧည့်သည်သုံးဦးစလုံးအတွက် လက်ဖက်ရည်မရွေးရသေးပါ! မပို့မီ လူတိုင်းအတွက် အော်ဒါရွေးချယ်ပါ။",
		"feedback_solved": "🎉 မှန်ကန်ပါပေတယ်! ဧည့်သည်အားလုံး သူတို့ကြိုက်တဲ့ လက်ဖက်ရည်ကို သောက်နေကြပါပြီ!\nလက်ဖက်ရည်ဆရာ ကိုဇော်က သဘောကျစွာ ခေါင်းညိတ်ပြီး ဆိပ်ကမ်းကုန်လက်မှတ်ကို ပေးအပ်လိုက်ပါသည်!",
		"feedback_solved_summary": "ဧည့်သည်အားလုံး လက်ဖက်ရည်ရရှိသွားပါပြီ! ဆိပ်ကမ်းကုန်လက်မှတ်ကို မှတ်စုစာအုပ်တွင် မှတ်တမ်းတင်ပြီးပါပြီ။",
		"feedback_0": "❌ တစ်ခွက်မှ မကိုက်ညီသေးပါ!\nသဲလွန်စ - မျက်စိပွင့်စေရန် အပြစ်သောက်သူ၊ အချိုစိမ့်ကြိုက်သူနှင့် အချိုပေါ့သောက်သူကို ခွဲခြားပါ။",
		"feedback_1": "❌ ၃ ခွက်တွင် ၁ ခွက်သာ မှန်သေးသည်!\nသဲလွန်စ - ဆရာမင်းက ချိုပြစ်၊ ကိုအောင်က ပေါ့စိမ့် သောက်လိုသည်။",
		"feedback_2": "❌ အနီးစပ်ဆုံး ဖြစ်နေပါပြီ! ၂ ခွက်မှန်သော်လည်း ၁ ခွက် မှားနေဆဲဖြစ်သည်!\nချိုစိမ့် နှင့် ချိုပြစ် ကွာခြားချက်ကို ပြန်စစ်ပါ။"
	}
}

const MARKET_PUZZLE: Dictionary = {
	"en": {
		"title": "📦 VENDOR'S MISSING NOTEBOOK PUZZLE",
		"subtitle": "Align the three tumbler combination dials to unlock Ko Lin's iron spice chest",
		"status_locked": "STATUS: LOCKED 🔒",
		"status_unlocked": "STATUS: UNLOCKED ✔",
		"unlock_btn": "Unlock Spice Chest 🔓",
		"unlocked_btn": "Chest Unlocked ✔",
		"card_titles": {
			"emblem": "Dial 1: Market Emblem",
			"stash": "Dial 2: Storage Bay",
			"spice": "Dial 3: Secret Seasoning"
		},
		"card_prompts": {
			"emblem": "Set Emblem Dial:",
			"stash": "Set Location Dial:",
			"spice": "Set Seasoning Dial:"
		},
		"card_hints": {
			"emblem": "\"The royal emblem stamped on the antique brass coin discovered between lime baskets at the fruit stand.\"",
			"stash": "\"The riverfront cargo staging area matching the port seals and the moored wooden riverboat crates.\"",
			"spice": "\"Ko Lin's secret spice mixture that makes his midnight pork skewers famous across the entire Strand Road market.\""
		},
		"emblem_choices": [
			"-- Select Market Emblem --",
			"Royal Burmese Peacock Seal",
			"Lion (Chinthe) Temple Seal",
			"Lotus Flower Guild Seal"
		],
		"stash_choices": [
			"-- Select Storage Location --",
			"Pier 4 Riverboat Cargo Stash",
			"Sule Pagoda Bus Depot",
			"Strand Road Coal Wharf"
		],
		"spice_choices": [
			"-- Select Secret Seasoning --",
			"Shan Star Anise & Dried Chili",
			"Sweet Cane Sugar & Cinnamon",
			"Crushed Tamarind & Salt"
		],
		"feedback_init": "Inspect the market stalls, fruit baskets, and riverboat crates to deduce the three tumbler dials.",
		"feedback_incomplete": "⚠️ You must set all three combination dials before attempting to unlock the chest!",
		"feedback_solved": "🎉 Click-clack! The heavy brass lock snaps open!\nInside lies Ko Lin's missing notebook, revealing the midnight delivery passcode (1886) to the Downtown Heritage Vault!",
		"feedback_solved_summary": "Ko Lin's notebook and delivery ledger are safely recovered! Check your notebook for the secret midnight delivery passcode.",
		"feedback_0": "❌ The tumbler lock resists! None of the dials are currently aligned.\nHint: Check the emblem on the coin in the fruit stand, the boat storage bay, and Ko Lin's skewer seasoning.",
		"feedback_1": "❌ 1 of the 3 dials clicks into place, but the other two are incorrect.\nHint: Remember the antique coin showed a Royal Peacock seal, and the riverboat is moored at Pier 4.",
		"feedback_2": "❌ Almost there! 2 of the 3 dials are aligned, but 1 tumbler is still stuck.\nDouble-check Ko Lin's fragrant Shan Star Anise & chili seasoning!"
	},
	"my": {
		"title": "📦 ဈေးသည်၏ ပျောက်ဆုံးမှတ်စုစာအုပ် ပဟေဠိ",
		"subtitle": "ကိုလင်း၏ သံဟင်းခတ်သေတ္တာသော့ပွင့်စေရန် သော့ခလုတ်သုံးခုကို ချိန်ညှိပါ",
		"status_locked": "အခြေအနေ - သော့ခတ်ထားသည် 🔒",
		"status_unlocked": "အခြေအနေ - ဖွင့်ပြီးပါပြီ ✔",
		"unlock_btn": "သေတ္တာသော့ဖွင့်မည် 🔓",
		"unlocked_btn": "သေတ္တာပွင့်သွားပါပြီ ✔",
		"card_titles": {
			"emblem": "ခလုတ် ၁ - စျေးတံဆိပ်တော်",
			"stash": "ခလုတ် ၂ - သိုလှောင်ရာနေရာ",
			"spice": "ခလုတ် ၃ - လျှို့ဝှက်အမွှေးအကြိုင်"
		},
		"card_prompts": {
			"emblem": "တံဆိပ်တော် ရွေးချယ်ပါ -",
			"stash": "နေရာ ရွေးချယ်ပါ -",
			"spice": "အမွှေးအကြိုင် ရွေးချယ်ပါ -"
		},
		"card_hints": {
			"emblem": "\"သစ်သီးဆိုင်မှ သံပရာသီးခြင်းကြားတွင် တွေ့ရှိရသော ရှေးဟောင်းကြေးဒင်္ဂါးပြားပေါ်မှ တော်ဝင်တံဆိပ်တော်။\"",
			"stash": "\"ဆိပ်ကမ်းတံဆိပ်တုံးများနှင့် ကုန်တင်လှေပေါ်ရှိ သေတ္တာများနှင့် ကိုက်ညီသော ဆိပ်ခံသိုလှောင်ရာနေရာ။\"",
			"spice": "\"ကမ်းနားလမ်းညဈေးတစ်ခုလုံးတွင် လူကြိုက်အများဆုံးဖြစ်သော ကိုလင်း၏ လျှို့ဝှက်အသားကင်မဆလာအရသာ။\""
		},
		"emblem_choices": [
			"-- စျေးတံဆိပ်တော် ရွေးချယ်ပါ --",
			"တော်ဝင်ဒေါင်းတံဆိပ်တော်",
			"ခြင်္သေ့မင်းတံဆိပ်",
			"ကြာပန်းတံဆိပ်"
		],
		"stash_choices": [
			"-- သိုလှောင်ရာနေရာ ရွေးချယ်ပါ --",
			"အမှတ် (၄) ဆိပ်ခံတံတား ကုန်သိုလှောင်ရာ",
			"ဆူးလေဘုရား ကားဂိတ်",
			"ကမ်းနားလမ်း ကျောက်မီးသွေးဆိပ်"
		],
		"spice_choices": [
			"-- လျှို့ဝှက်အမွှေးအကြိုင် ရွေးချယ်ပါ --",
			"ရှမ်းနာနတ်ပွင့်နှင့် ငရုတ်သီးခြောက်",
			"ကြံသကြားနှင့် သစ်ကြံပိုးခေါက်",
			"မန်ကျည်းသီးနှင့် ဆား"
		],
		"feedback_init": "သစ်သီးဆိုင်၊ သစ်သီးခြင်းများနှင့် ကုန်တင်လှေပေါ်ရှိ သေတ္တာများကို စစ်ဆေးကာ သော့ခလုတ် ၃ ခုကို ဖော်ထုတ်ပါ။",
		"feedback_incomplete": "⚠️ သေတ္တာမဖွင့်မီ သော့ခလုတ်သုံးခုစလုံးကို ရွေးချယ်ချိန်ညှိပေးရပါမည်!",
		"feedback_solved": "🎉 ကလစ်! ကြေးသော့ကြီး ပွင့်သွားပါပြီ!\nအတွင်းတွင် ကိုလင်း၏ ပျောက်ဆုံးမှတ်စုစာအုပ် တွေ့ရှိရပြီး မြို့လယ်ရှေးဟောင်းတိုက်အတွက် လျှို့ဝှက်ကုဒ် (၁၈၈၆) ကို ဖော်ထုတ်နိုင်ခဲ့ပါပြီ!",
		"feedback_solved_summary": "ကိုလင်း၏ မှတ်စုစာအုပ်ကို ပြန်လည်ရရှိပါပြီ! မြို့လယ်တိုက်ခန်း လျှို့ဝှက်ကုဒ်ကို မှတ်စုစာအုပ်တွင် စစ်ဆေးပါ။",
		"feedback_0": "❌ သော့ခလုတ် မပွင့်သေးပါ! တစ်ခုမှ မကိုက်ညီသေးပါ။\nသဲလွန်စ - သစ်သီးဆိုင်မှ ဒင်္ဂါးပြားတံဆိပ်၊ ကုန်တင်လှေ သိုလှောင်ခန်းနှင့် ကိုလင်း၏ အမွှေးအကြိုင်ကို စစ်ဆေးပါ။",
		"feedback_1": "❌ ၃ ခုအနက် ၁ ခုသာ နေရာကျသေးသည်!\nသဲလွန်စ - ဒင်္ဂါးပြားတွင် တော်ဝင်ဒေါင်းတံဆိပ်ပါပြီး လှေမှာ ဆိပ်ခံ ၄ တွင် ဆိုက်ကပ်ထားသည်။",
		"feedback_2": "❌ အနီးစပ်ဆုံး ရောက်နေပါပြီ! ၂ ခု ကိုက်ညီသော်လည်း ၁ ခု လိုနေသေးသည်!\nကိုလင်း၏ မွှေးကြိုင်သော ရှမ်းနာနတ်ပွင့်နှင့် ငရုတ်သီးခြောက် အရသာကို သတိပြုပါ။"
	}
}

const DELIVERY_PUZZLE: Dictionary = {
	"en": {
		"title": "🏛️ HERITAGE VAULT DISPATCH CONSOLE",
		"subtitle": "Synthesize your investigation evidence to verify and complete the final midnight delivery",
		"status_pending": "STATUS: PENDING 🔒",
		"status_delivered": "STATUS: DELIVERED ✔",
		"deliver_btn": "Verify & Complete Delivery 📦",
		"ending_btn": "View Mystery Resolution 🏆",
		"card_titles": {
			"seal": "1. Cargo Manifest Seal",
			"passcode": "2. Dispatch Passcode",
			"recipient": "3. Authorized Sentry"
		},
		"card_prompts": {
			"seal": "Select Cargo Seal:",
			"passcode": "Select Dispatch Code:",
			"recipient": "Select Recipient:"
		},
		"card_hints": {
			"seal": "\"The royal seal stamped on the harbor cargo manifest recovered after solving the tea shop orders.\"",
			"passcode": "\"The secret four-digit vault passcode written in vendor Ko Lin's recovered market ledger.\"",
			"recipient": "\"The trusted colonial night watchman assigned to guard the heritage repository at Sule Pagoda.\""
		},
		"seal_choices": [
			"-- Select Cargo Seal --",
			"Royal Hintha Bird Seal (Pier 4 Manifest)",
			"Peacock Market Token",
			"Standard British Harbor Anchor"
		],
		"passcode_choices": [
			"-- Select Dispatch Passcode --",
			"Passcode: 1008 (Sule Pagoda)",
			"Passcode: 1886 (Vendor's Secret Ledger)",
			"Passcode: 1948 (Independence Era)",
			"Passcode: 2024 (Modern Transit)"
		],
		"recipient_choices": [
			"-- Select Authorized Recipient --",
			"Night Watchman U Ba (Heritage Vault Sentry)",
			"Rogue Harbor Smuggler",
			"Unregistered Riverboat Courier"
		],
		"feedback_init": "Consult your Investigator's Notebook: synthesize the Harbor Cargo Manifest Seal, the Vendor's Passcode, and the Authorized Sentry.",
		"feedback_incomplete": "⚠️ You must complete all three verification fields before finalizing the cargo delivery!",
		"feedback_solved": "🎉 CLANG! The massive iron gears turn! Night Watchman U Ba signs the registry and secures the antique relics into the Heritage Vault!",
		"feedback_solved_summary": "The midnight cargo is safely delivered! Yangon's historic relics are locked inside the Downtown vault.",
		"feedback_0": "❌ Delivery verification rejected! None of the dispatch entries match your investigation clues.\nHint: Re-read the Harbor Cargo Slip from the Tea Shop and the Ledger from the Market.",
		"feedback_1": "❌ 1 of the 3 verification fields is correct, but the vault protocol remains locked.\nHint: The harbor manifest specifies the Royal Hintha Bird seal, and Ko Lin's ledger revealed Passcode 1886.",
		"feedback_2": "❌ Almost verified! 2 of 3 fields match, but 1 entry failed security check.\nEnsure the authorized vault recipient is the faithful colonial sentry, Night Watchman U Ba!"
	},
	"my": {
		"title": "🏛️ ရှေးဟောင်းတိုက် ကုန်စည်ပို့ဆောင်ရေးခလုတ်ခုံ",
		"subtitle": "သန်းခေါင်ယံကုန်စည်ပို့ဆောင်မှု အောင်မြင်စေရန် စုံစမ်းရရှိထားသော သက်သေများကို ပေါင်းစပ်အတည်ပြုပါ",
		"status_pending": "အခြေအနေ - စောင့်ဆိုင်းဆဲ 🔒",
		"status_delivered": "အခြေအနေ - ပို့ဆောင်ပြီးပါပြီ ✔",
		"deliver_btn": "အတည်ပြုပြီး ပို့ဆောင်မည် 📦",
		"ending_btn": "ဇာတ်သိမ်းမှတ်တမ်း ကြည့်ရှုမည် 🏆",
		"card_titles": {
			"seal": "၁။ ကုန်စည်တံဆိပ်တော်",
			"passcode": "၂။ ပို့ဆောင်ရေး လျှို့ဝှက်ကုဒ်",
			"recipient": "၃။ တရားဝင်တိုက်ခန်းစောင့်"
		},
		"card_prompts": {
			"seal": "တံဆိပ်တော် ရွေးချယ်ပါ -",
			"passcode": "လျှို့ဝှက်ကုဒ် ရွေးချယ်ပါ -",
			"recipient": "လက်ခံမည့်သူ ရွေးချယ်ပါ -"
		},
		"card_hints": {
			"seal": "\"လက်ဖက်ရည်ဆိုင် အော်ဒါများ ဖြေရှင်းပြီးနောက် ရရှိခဲ့သော ဆိပ်ကမ်းကုန်လက်မှတ်ပါ တော်ဝင်တံဆိပ်တော်။\"",
			"passcode": "\"ဈေးသည် ကိုလင်း၏ မှတ်စုစာအုပ်ထဲတွင် ရေးသားထားသော ဂဏန်းလေးလုံးပါ လျှို့ဝှက်ကုဒ်။\"",
			"recipient": "\"ဆူးလေစေတီအနီး ကိုလိုနီခေတ် ရှေးဟောင်းအမွေအနှစ်တိုက်ကို စောင့်ရှောက်နေသော သစ္စာရှိ ညစောင့်ကြီး။\""
		},
		"seal_choices": [
			"-- ကုန်စည်တံဆိပ်တော် ရွေးချယ်ပါ --",
			"ဟင်္သာမင်း တံဆိပ်တော် (ဆိပ်ခံ ၄ ကုန်စာရင်း)",
			"ဒေါင်းတံဆိပ် ဈေးဒင်္ဂါး",
			"ဆိပ်ကမ်း ကျောက်ဆူးတံဆိပ်"
		],
		"passcode_choices": [
			"-- လျှို့ဝှက်ကုဒ် ရွေးချယ်ပါ --",
			"ကုဒ် - ၁၀၀၈ (ဆူးလေစေတီ)",
			"ကုဒ် - ၁၈၈၆ (ဈေးသည်၏ စာရင်းစာအုပ်)",
			"ကုဒ် - ၁၉၄၈ (လွတ်လပ်ရေးခေတ်)",
			"ကုဒ် - ၂၀၂၄ (မျက်မှောက်ခေတ်)"
		],
		"recipient_choices": [
			"-- လက်ခံမည့်သူ ရွေးချယ်ပါ --",
			"ညစောင့် ဦးဘ (ရှေးဟောင်းတိုက် စောင့်)",
			"ဆိပ်ကမ်းမှောင်ခိုသမား",
			"မှတ်ပုံမတင်ထားသော ကုန်တင်လှေသား"
		],
		"feedback_init": "စုံထောက်မှတ်စုစာအုပ်ကို စစ်ဆေးပါ - ဆိပ်ကမ်းကုန်လက်မှတ်တံဆိပ်၊ ကိုလင်း၏ကုဒ်နှင့် ညစောင့်ဦးဘကို ပေါင်းစပ်အတည်ပြုပါ။",
		"feedback_incomplete": "⚠️ ကုန်စည်ပို့ဆောင်မှု မပြီးဆုံးမီ စစ်ဆေးချက် ၃ ချက်စလုံးကို ဖြည့်သွင်းရပါမည်!",
		"feedback_solved": "🎉 ဂလောက်! သံတံခါးကြီး ပွင့်သွားပါပြီ! ညစောင့်ဦးဘက လက်မှတ်ရေးထိုးပြီး ရှေးဟောင်းအမွေအနှစ်များကို တိုက်ခန်းထဲသို့ ဘေးကင်းစွာ သွင်းယူလိုက်ပါသည်!",
		"feedback_solved_summary": "သန်းခေါင်ယံကုန်စည်ကို အောင်မြင်စွာ ပို့ဆောင်ပြီးပါပြီ! သမိုင်းဝင်အမွေအနှစ်များ တိုက်ခန်းထဲတွင် လုံခြုံသွားပါပြီ။",
		"feedback_0": "❌ ကုန်စည်ပို့ဆောင်မှု မအောင်မြင်ပါ! တစ်ခုမှ သဲလွန်စများနှင့် မကိုက်ညီသေးပါ။\nသဲလွန်စ - လက်ဖက်ရည်ဆိုင်မှ ကုန်လက်မှတ်နှင့် ဈေးမှ စာရင်းစာအုပ်ကို ပြန်ဖတ်ပါ။",
		"feedback_1": "❌ ၃ ချက်တွင် ၁ ချက်သာ မှန်သေးသည်!\nသဲလွန်စ - ဆိပ်ကမ်းကုန်လက်မှတ်တွင် ဟင်္သာတံဆိပ်ပါပြီး ကိုလင်း၏ စာအုပ်တွင် ကုဒ် ၁၈၈၆ ပါရှိသည်။",
		"feedback_2": "❌ အနီးစပ်ဆုံး ဖြစ်နေပါပြီ! ၂ ချက်မှန်သော်လည်း ၁ ချက် လိုနေသေးသည်!\nတိုက်ခန်းစောင့်အဖြစ် သစ္စာရှိသော ညစောင့် ဦးဘ ကို ရွေးချယ်ပါ။"
	}
}

const ENDING: Dictionary = {
	"en": {
		"pretitle": "★ INVESTIGATION CONCLUDED ★",
		"title": "YANGON AFTER HOURS — CASE CLOSED",
		"subtitle": "The Midnight Mystery of Strand Road has been Solved",
		"narrative": "Through the rain-washed streets of downtown Sule, the sweet tea aromas of 38th Street, and the vibrant riverfront stalls of Strand Road, you tracked down every missing thread.\n\n• You untangled the crowded tea orders for Saya Min, Ma Thida, and Ko Aung, obtaining the harbor cargo slip.\n• You cracked the combination lock on Ko Lin's iron spice chest at the Night Market, safely recovering his missing grandfather's recipe and delivery ledger.\n• Synthesizing the Royal Hintha Seal and Secret Passcode 1886, you verified the midnight delivery with Night Watchman U Ba and secured the stolen colonial brass relics inside the Downtown Heritage Vault.\n\nAs the first golden rays of dawn rise over Sule Pagoda, the steam from the tea shop kettles drifts into the cool morning breeze. The historic treasures of Yangon are safe once more.",
		"clues_stat": "📓 Clues Collected: %d / 7",
		"puzzles_stat": "🧩 Puzzles Solved: %d / 3",
		"locations_stat": "🏙️ Locations Explored: 3 / 3",
		"restart_btn": "↺ Play Again (New Game)",
		"freeroam_btn": "🗺️ Return to City Map"
	},
	"my": {
		"pretitle": "★ စုံစမ်းစစ်ဆေးမှု ပြီးဆုံးပါပြီ ★",
		"title": "ရန်ကုန်ညဉ့်နက်ချိန် — အမှုပြီးဆုံးပါပြီ",
		"subtitle": "ကမ်းနားလမ်း၏ ညဉ့်နက်လျှို့ဝှက်ဆန်းကြယ်မှုကို အောင်မြင်စွာ ဖော်ထုတ်နိုင်ခဲ့ပါပြီ",
		"narrative": "မိုးစိုရွှဲနေသော ဆူးလေမြို့လယ်လမ်းများ၊ ၃၈ လမ်း လက်ဖက်ရည်ဆိုင်၏ မွှေးကြိုင်သောအနံ့နှင့် ကမ်းနားလမ်းညဈေးတန်းတို့မှတစ်ဆင့် သင်သည် လျှို့ဝှက်ချက်အားလုံးကို စုံစမ်းဖော်ထုတ်နိုင်ခဲ့ပါပြီ။\n\n• ဆရာမင်း၊ မသီတာနှင့် ကိုအောင်တို့၏ လက်ဖက်ရည်အော်ဒါများကို ဖြေရှင်းပေးကာ ဆိပ်ကမ်းကုန်လက်မှတ်ကို ရရှိခဲ့သည်။\n• ညဈေးတန်းတွင် ကိုလင်း၏ သံဟင်းခတ်သေတ္တာသော့ကို ဖွင့်ပေးပြီး အဘိုးဖြစ်သူ၏ ပျောက်ဆုံးလက်ရာနှင့် ပို့ဆောင်ရေးစာအုပ်ကို ပြန်လည်ရယူပေးခဲ့သည်။\n• ဟင်္သာမင်းတံဆိပ်တော်နှင့် လျှို့ဝှက်ကုဒ် ၁၈၈၆ ကို ပေါင်းစပ်ကာ ညစောင့်ဦးဘထံသို့ သန်းခေါင်ယံကုန်စည်ကို အောင်မြင်စွာ ပို့ဆောင်ပေးနိုင်ခဲ့ပြီး ခိုးယူခံရသော ကိုလိုနီခေတ်ကြေးထည်များကို ရှေးဟောင်းတိုက်ထဲ လုံခြုံစွာ ထိန်းသိမ်းနိုင်ခဲ့သည်။\n\nဆူးလေစေတီတော်ပေါ်သို့ အရုဏ်ဦးနေရောင်ခြည် စတင်ကျရောက်လာချိန်တွင် လက်ဖက်ရည်ဆိုင်မှ ရေနွေးငွေ့များသည် နံနက်ခင်းမြစ်လေညင်းနှင့်အတူ ပျံ့လွင့်နေသည်။ ရန်ကုန်၏ သမိုင်းဝင်အမွေအနှစ်များသည် ဘေးကင်းလုံခြုံသွားပါပြီ။",
		"clues_stat": "📓 တွေ့ရှိသော သဲလွန်စများ - %d / ၇",
		"puzzles_stat": "🧩 ဖြေရှင်းပြီးသော ပဟေဠိများ - %d / ၃",
		"locations_stat": "🏙️ စူးစမ်းခဲ့သော နေရာများ - ၃ / ၃",
		"restart_btn": "↺ တစ်ကျော့ပြန်ကစားမည်",
		"freeroam_btn": "🗺️ မြို့ပြမြေပုံသို့ ပြန်သွားမည်"
	}
}

static func get_ui_text(key: String, lang: String) -> String:
	var l = lang if lang == "my" else "en"
	if UI_TEXTS[l].has(key):
		return UI_TEXTS[l][key]
	
	var upper_key = key.to_upper()
	if UI_TEXTS[l].has(upper_key):
		return UI_TEXTS[l][upper_key]
	
	var aliases = {
		"UI_GAME_TITLE": "MENU_TITLE",
		"UI_TITLE": "MENU_TITLE",
		"UI_CITY_MAP_TITLE": "MAP_TITLE",
		"UI_CITY_MAP_STATUS": "MAP_SUBTITLE",
		"UI_BACK_MENU": "MAP_BACK_MENU",
		"UI_BACK_MAP": "BACK_TO_MAP",
		"UI_NOTEBOOK_BTN": "NOTEBOOK_BTN",
		"LOC_DOWNTOWN_TITLE": "LOC_DOWNTOWN_TITLE",
		"LOC_TEA_SHOP_TITLE": "LOC_TEA_SHOP_TITLE",
		"LOC_MARKET_TITLE": "LOC_MARKET_TITLE",
		"DIALOGUE_CLUE_RECORDED": "CLUE_RECORDED"
	}
	if aliases.has(upper_key):
		var mapped = aliases[upper_key]
		if UI_TEXTS[l].has(mapped):
			return UI_TEXTS[l][mapped]
	
	return UI_TEXTS["en"].get(key, UI_TEXTS["en"].get(upper_key, key))

static func get_location_data(loc_id: String, lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	var title_key = "LOC_" + loc_id.to_upper() + "_TITLE"
	var sub_key = "LOC_" + loc_id.to_upper() + "_SUB"
	var desc_key = "LOC_" + loc_id.to_upper() + "_DESC"
	return {
		"title": get_ui_text(title_key, l),
		"subtitle": get_ui_text(sub_key, l),
		"description": get_ui_text(desc_key, l)
	}

static func get_hotspot_data(hotspot_name: String, lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	if HOTSPOTS.has(hotspot_name):
		var h = HOTSPOTS[hotspot_name]
		if h.has(l):
			return h[l]
		elif h.has("en"):
			return h["en"]
	return {}

static func get_clue_data(clue_id: String, lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	if CLUES.has(clue_id):
		var c = CLUES[clue_id]
		var data: Dictionary = {}
		if c.has(l):
			data = c[l].duplicate()
		elif c.has("en"):
			data = c["en"].duplicate()
		data["icon"] = c.get("icon", "🔍")
		if data.has("description") and not data.has("desc"):
			data["desc"] = data["description"]
		elif data.has("desc") and not data.has("description"):
			data["description"] = data["desc"]
		return data
	return {}

static func get_deduction_data(deduction_id: String, lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	if DEDUCTIONS.has(deduction_id):
		var d = DEDUCTIONS[deduction_id]
		var data: Dictionary = {}
		if d.has(l):
			data = d[l].duplicate(true)
		elif d.has("en"):
			data = d["en"].duplicate(true)
		data["id"] = deduction_id
		data["icon"] = d.get("icon", "💡")
		data["clues"] = d.get("clues", []).duplicate()
		return data
	return {}

static func get_all_deductions_data(lang: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for did in DEDUCTIONS:
		result.append(get_deduction_data(did, lang))
	return result

static func get_tea_puzzle_data(lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	var data: Dictionary = TEA_PUZZLE[l].duplicate()
	if not data.has("tea_choices") and data.has("choices"):
		data["tea_choices"] = data["choices"]
	if not data.has("btn_serve") and data.has("serve_btn"):
		data["btn_serve"] = data["serve_btn"]
	if not data.has("btn_served") and data.has("served_btn"):
		data["btn_served"] = data["served_btn"]
	if not data.has("btn_close"):
		data["btn_close"] = "✕ ပိတ်မည်" if l == "my" else "✕ Close"
	if not data.has("customer_hints") and data.has("hints") and data.has("customer_names"):
		data["customer_hints"] = {
			"min": {"name": data["customer_names"].get("min", ""), "hint": data["hints"].get("min", "")},
			"thida": {"name": data["customer_names"].get("thida", ""), "hint": data["hints"].get("thida", "")},
			"aung": {"name": data["customer_names"].get("aung", ""), "hint": data["hints"].get("aung", "")}
		}
	return data

static func get_market_puzzle_data(lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	var data: Dictionary = MARKET_PUZZLE[l].duplicate()
	if not data.has("btn_unlock") and data.has("unlock_btn"):
		data["btn_unlock"] = data["unlock_btn"]
	if not data.has("btn_unlocked") and data.has("unlocked_btn"):
		data["btn_unlocked"] = data["unlocked_btn"]
	if not data.has("btn_cancel"):
		data["btn_cancel"] = "မလုပ်တော့ပါ" if l == "my" else "Cancel"
	if not data.has("btn_close"):
		data["btn_close"] = "✕ ပိတ်မည်" if l == "my" else "✕ Close"
	if not data.has("dials") and data.has("card_titles"):
		data["dials"] = {
			"emblem": {
				"name": data["card_titles"].get("emblem", ""),
				"hint": data["card_hints"].get("emblem", ""),
				"prompt": data["card_prompts"].get("emblem", "")
			},
			"stash": {
				"name": data["card_titles"].get("stash", ""),
				"hint": data["card_hints"].get("stash", ""),
				"prompt": data["card_prompts"].get("stash", "")
			},
			"spice": {
				"name": data["card_titles"].get("spice", ""),
				"hint": data["card_hints"].get("spice", ""),
				"prompt": data["card_prompts"].get("spice", "")
			}
		}
	return data

static func get_delivery_puzzle_data(lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	var data: Dictionary = DELIVERY_PUZZLE[l].duplicate()
	if not data.has("btn_deliver") and data.has("deliver_btn"):
		data["btn_deliver"] = data["deliver_btn"]
	if not data.has("btn_delivered") and data.has("delivered_btn"):
		data["btn_delivered"] = data["delivered_btn"]
	if not data.has("btn_ending") and data.has("ending_btn"):
		data["btn_ending"] = data["ending_btn"]
	if not data.has("btn_cancel"):
		data["btn_cancel"] = "မလုပ်တော့ပါ" if l == "my" else "Cancel"
	if not data.has("btn_close"):
		data["btn_close"] = "✕ ပိတ်မည်" if l == "my" else "✕ Close"
	if not data.has("fields") and data.has("card_titles"):
		data["fields"] = {
			"seal": {
				"name": data["card_titles"].get("seal", ""),
				"hint": data["card_hints"].get("seal", ""),
				"prompt": data["card_prompts"].get("seal", "")
			},
			"passcode": {
				"name": data["card_titles"].get("passcode", ""),
				"hint": data["card_hints"].get("passcode", ""),
				"prompt": data["card_prompts"].get("passcode", "")
			},
			"recipient": {
				"name": data["card_titles"].get("recipient", ""),
				"hint": data["card_hints"].get("recipient", ""),
				"prompt": data["card_prompts"].get("recipient", "")
			}
		}
	return data

static func get_ending_data(lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	return ENDING[l]

const INSPECTION_OBJECTS: Dictionary = {
	"tea_notebook": {
		"en": {
			"title": "Abandoned Leather Notebook",
			"subtitle": "Table 3 • Lucky Tea Shop",
			"texture_path": "res://assets/inspect/tea_notebook.png",
			"areas": [
				{
					"id": "notebook_clasp",
					"name": "Brass Schooner Clasp",
					"rect": Rect2(45, 160, 50, 65),
					"observation": "A worn brass clasp embossed with a three-masted schooner—the emblem of an old trading firm operating on Strand Road."
				},
				{
					"id": "notebook_cipher",
					"name": "Cipher in Notebook Page",
					"rect": Rect2(265, 70, 150, 130),
					"observation": "Beneath tea stains, hurried handwriting reads: 'Deliver parcel to Pier 4 before midnight whistle. Watch the shadows.' A crucial clue!",
					"clue_id": "tea_notebook_cipher"
				},
				{
					"id": "notebook_pocket",
					"name": "Inner Pocket & Blotting Paper",
					"rect": Rect2(95, 230, 140, 80),
					"observation": "Tucked inside the back lining is pink blotting paper smelling faintly of sandalwood incense and harbor riverboat kerosene."
				}
			]
		},
		"my": {
			"title": "ကျန်ရစ်ခဲ့သော သားရေမှတ်စုစာအုပ်",
			"subtitle": "စားပွဲအမှတ် (၃) • လပ်ကီးလက်ဖက်ရည်ဆိုင်",
			"texture_path": "res://assets/inspect/tea_notebook.png",
			"areas": [
				{
					"id": "notebook_clasp",
					"name": "ကြေးရောင် သင်္ဘောတံဆိပ် ခတ်ကွင်း",
					"rect": Rect2(45, 160, 50, 65),
					"observation": "ကမ်းနားလမ်းမှ ကိုလိုနီကုန်သွယ်ရေးကုမ္ပဏီတစ်ခု၏ အမှတ်တံဆိပ်ဖြစ်သော သုံးရွက်တိုင်ရွက်လှေပုံ ရိုက်နှိပ်ထားသည့် ကြေးသော့ခတ်ကွင်းဟောင်း။"
				},
				{
					"id": "notebook_cipher",
					"name": "လျှို့ဝှက်ကုဒ် ရေးထားသော စာမျက်နှာ",
					"rect": Rect2(265, 70, 150, 130),
					"observation": "လက်ဖက်ရည်စွန်းထင်းမှုများအောက်တွင် 'သန်းခေါင်ယံ ဥဩမဆွဲမီ အထုပ်ကို ဆိပ်ခံတံတား (၄) သို့ ပို့ပါ။ အရိပ်တွေကို သတိထားပါ' ဟု ရေးထားသော အရေးကြီးသဲလွန်စ!",
					"clue_id": "tea_notebook_cipher"
				},
				{
					"id": "notebook_pocket",
					"name": "အတွင်းအိတ်ကပ်နှင့် စက္ကူစုတ်",
					"rect": Rect2(95, 230, 140, 80),
					"observation": "အတွင်းအိတ်ကပ်ထဲတွင် စန္ဒကူးနံ့နှင့် ရေနံနံ့သင်းနေသော ပန်းရောင်မှင်စုပ်စက္ကူအပိုင်းအစတစ်ခု ညှပ်ထားသည်။"
				}
			]
		}
	},
	"tea_receipt": {
		"en": {
			"title": "Crinkled Tea Shop Receipt",
			"subtitle": "Cashier Counter • Lucky Tea Shop",
			"texture_path": "res://assets/inspect/tea_receipt.png",
			"areas": [
				{
					"id": "receipt_items",
					"name": "Order Items",
					"rect": Rect2(150, 85, 210, 130),
					"observation": "Order #44: 2x Sweet Milk Tea, 1x Bitter Black, 3x Hot Samosas. Total: 2,500 Kyats. Three customers were sitting together at Table 3."
				},
				{
					"id": "receipt_timestamp",
					"name": "Cash Register Timestamp",
					"rect": Rect2(240, 115, 115, 65),
					"observation": "A purple ink stamp clearly prints: '11:42 PM - Lucky Tea Shop'. This bill was paid just three minutes before the commotion!",
					"clue_id": "tea_receipt_timestamp"
				},
				{
					"id": "receipt_scribble",
					"name": "Handwritten Note on Back",
					"rect": Rect2(160, 250, 190, 60),
					"observation": "In dark blue ballpoint ink, someone hastily wrote: 'Vault Key with Watchman U Ba'. Could the night watchman be involved?"
				}
			]
		},
		"my": {
			"title": "တွန့်ကျေနေသော လက်ဖက်ရည်ဆိုင် ဘေလ်ဖြတ်ပိုင်း",
			"subtitle": "ငွေကိုင်ကောင်တာ • လပ်ကီးလက်ဖက်ရည်ဆိုင်",
			"texture_path": "res://assets/inspect/tea_receipt.png",
			"areas": [
				{
					"id": "receipt_items",
					"name": "မှာယူထားသော စာရင်း",
					"rect": Rect2(150, 85, 210, 130),
					"observation": "အော်ဒါ #၄၄ - ချိုစိမ့် ၂ ခွက်၊ အခါး ၁ ခွက်၊ စမူဆာ ၃ ခု။ စုစုပေါင်း ၂,၅၀၀ ကျပ်။ ဧည့်သည် ၃ ဦး စားပွဲ (၃) တွင် အတူထိုင်ခဲ့ကြသည်။"
				},
				{
					"id": "receipt_timestamp",
					"name": "ငွေကိုင်စက် အချိန်တံဆိပ်",
					"rect": Rect2(240, 115, 115, 65),
					"observation": "ခရမ်းရောင်မှင်ဖြင့် '၁၁:၄၂ ည - လပ်ကီးလက်ဖက်ရည်ဆိုင်' ဟု တံဆိပ်ရိုက်ထားသည်။ ဧည့်သည် ပြေးထွက်မသွားမီ ၃ မိနစ်အလိုက ရှင်းထားသောဘေလ်!",
					"clue_id": "tea_receipt_timestamp"
				},
				{
					"id": "receipt_scribble",
					"name": "ကျောဘက် လက်ရေးမှတ်စု",
					"rect": Rect2(160, 250, 190, 60),
					"observation": "အပြာရောင်ဘောပင်ဖြင့် 'သိုက်သော့ ဦးဘဆီတွင် ရှိသည်' ဟု ရေးထားသည်။ ညစောင့်ဦးဘ ပါဝင်ပတ်သက်နေသလား?"
				}
			]
		}
	},
	"tea_clock": {
		"en": {
			"title": "Antique Teak Wall Clock",
			"subtitle": "Dining Hall Wall • Lucky Tea Shop",
			"texture_path": "res://assets/inspect/tea_clock.png",
			"areas": [
				{
					"id": "clock_hands",
					"name": "Frozen Hands at 11:45 PM",
					"rect": Rect2(195, 110, 120, 120),
					"observation": "The ornate brass hands are jammed at 11:45 PM. The exact minute the tea shop lights surged and the stranger bolted into the rain!",
					"clue_id": "tea_clock_stopped_time"
				},
				{
					"id": "clock_glass",
					"name": "Cracked Glass Dial",
					"rect": Rect2(210, 85, 90, 60),
					"observation": "A sharp crack runs across the Roman numerals, likely struck by something hard during the frantic rush."
				},
				{
					"id": "clock_pendulum",
					"name": "Pendulum & Key Chamber",
					"rect": Rect2(195, 290, 120, 80),
					"observation": "Inside the pendulum glass housing, a small brass winding key hangs from a red silk cord. The pendulum is stationary."
				}
			]
		},
		"my": {
			"title": "ရှေးဟောင်း ကျွန်းသစ်နံရံကပ်နာရီ",
			"subtitle": "ဆိုင်နံရံ • လပ်ကီးလက်ဖက်ရည်ဆိုင်",
			"texture_path": "res://assets/inspect/tea_clock.png",
			"areas": [
				{
					"id": "clock_hands",
					"name": "၁၁:၄၅ တွင် ရပ်တန့်နေသော လက်တံများ",
					"rect": Rect2(195, 110, 120, 120),
					"observation": "လက်တံများသည် ညဉ့်နက် ၁၁:၄၅ အတိတွင် ရပ်တန့်နေသည်။ လက်ဖက်ရည်ဆိုင်မီးများ ဝင်းကနဲဖြစ်ပြီး သူစိမ်းပြေးထွက်သွားသည့် အချိန်အတိအကျ!",
					"clue_id": "tea_clock_stopped_time"
				},
				{
					"id": "clock_glass",
					"name": "အက်ကွဲနေသော မှန်မျက်နှာပြင်",
					"rect": Rect2(210, 85, 90, 60),
					"observation": "နံပါတ်များပေါ်တွင် အက်ရာတစ်ခု ထင်ကျန်နေသည်၊ ရုတ်ရုတ်သဲသဲဖြစ်စဉ် တစ်စုံတစ်ခုနှင့် ထိခိုက်မိခဲ့ပုံရသည်။"
				},
				{
					"id": "clock_pendulum",
					"name": "ချိန်သီးအိမ်နှင့် လျှို့ဝှက်ခန်း",
					"rect": Rect2(195, 290, 120, 80),
					"observation": "မှန်ချိန်သီးအိမ်ထဲတွင် ပိုးကြိုးနီလေးဖြင့် ချည်ထားသော ကြေးသော့ငယ်လေး ရှိနေသည်။ ချိန်သီးသည် ငြိမ်သက်နေသည်။"
				}
			]
		}
	}
}

static func get_inspection_data(object_id: String, lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	if INSPECTION_OBJECTS.has(object_id):
		var obj = INSPECTION_OBJECTS[object_id]
		if obj.has(l):
			return obj[l].duplicate(true)
		elif obj.has("en"):
			return obj["en"].duplicate(true)
	return {}

const CHARACTER_QUESTIONING: Dictionary = {
	"ko_zaw": {
		"speaker": {
			"en": "✦ Tea Master Ko Zaw",
			"my": "✦ လက်ဖက်ရည်ဆရာ ကိုဇော်"
		},
		"greetings": {
			"default": {
				"en": "Mingalarbar! Fresh tea is on the stove. How can I help your investigation, Detective?",
				"my": "မင်္ဂလာပါခင်ဗျာ! မီးဖိုပေါ်မှာ လက်ဖက်ရည် အဆင်သင့်ရှိပါတယ်။ စုံစမ်းစစ်ဆေးမှုအတွက် ဘာများ မေးမြန်းလိုပါသလဲခင်ဗျာ?"
			},
			"solved": {
				"en": "Mingalarbar! Thanks to your keen deduction, Table Three is happily drinking their favorite tea! How can I help your investigation?",
				"my": "မင်္ဂလာပါ! မင်းရဲ့ ထက်မြက်တဲ့ စုံစမ်းမှုကြောင့် စားပွဲအမှတ် (၃) က ဧည့်သည်တွေ လက်ဖက်ရည် သောက်နေကြပါပြီ! အခြား ဘာများ မေးချင်ပါသေးသလဲခင်ဗျာ?"
			},
			"after_confession": {
				"en": "Detective, I'm ready to answer anything honestly now. What else do you need to know?",
				"my": "စုံထောက်ကြီး၊ ကျွန်တော် အမှန်အတိုင်း အကုန် ဖြေဖို့ အဆင်သင့်ပါပဲဗျာ။ ဘာများ သိချင်ပါသေးသလဲခင်ဗျာ?"
			}
		},
		"questions": [
			{
				"id": "q_commotion",
				"text": {
					"en": "What happened during the late-night commotion?",
					"my": "ညဉ့်နက်ဖြစ်ပျက်ခဲ့တဲ့ အခြေအနေကို မေးမြန်းမည်"
				},
				"dialogue_initial": {
					"en": [
						"It was quiet until around midnight. A stranger in a dark raincoat was drinking tea at Table 3.",
						"Around 12:00 AM midnight, the shop lights surged and he bolted into the rain as lightning struck outside!"
					],
					"my": [
						"သန်းခေါင်ယံနီးတဲ့အထိ အေးအေးဆေးဆေးပါပဲ။ မိုးကာအင်္ကျီအမည်းနဲ့ လူတစ်ယောက် စားပွဲ ၃ မှာ လက်ဖက်ရည်ခါး သောက်နေခဲ့တယ်။",
						"ညဉ့်နက် ၁၂ နာရီလောက်မှာ ဆိုင်မီးတွေ ဝင်းကနဲဖြစ်ပြီး မိုးကြိုးပစ်တော့ သူ မိုးထဲရေထဲ အလောတကြီး ပြေးထွက်သွားတယ်ဗျာ!"
					]
				},
				"dialogue_revealed": {
					"en": [
						"As I admitted when you showed me that receipt—he didn't leave at midnight.",
						"He paid at 11:42 PM and bolted at 11:45 PM sharp, asking if Ko Aung's taxi was outside!"
					],
					"my": [
						"ဘေလ်ဖြတ်ပိုင်းကို ပြပြီးနောက် ကျွန်တော် ဝန်ခံခဲ့သလိုပါပဲ—သူ သန်းခေါင်ယံမှာ ထွက်သွားတာ မဟုတ်ပါဘူး။",
						"သူဟာ ၁၁:၄၂ မှာ ဘေလ်ရှင်းပြီး ၁၁:၄၅ အတိမှာ တက္ကစီဆရာ ကိုအောင် အပြင်မှာ ရှိမရှိ မေးပြီး ပြေးထွက်သွားခဲ့တာပါ!"
					]
				}
			},
			{
				"id": "q_table3",
				"text": {
					"en": "Tell me about the customers at Table 3.",
					"my": "စားပွဲ ၃ က ဧည့်သည် ၃ ဦးအကြောင်း မေးမြန်းမည်"
				},
				"dialogue": {
					"en": [
						"Saya Min the teacher, Ma Thida the trader, and Ko Aung the taxi driver were sitting there together.",
						"They were talking loudly about midnight harbor cargo when the stranger sat beside them. If you solve their tea orders, they might share more details!"
					],
					"my": [
						"ကျောင်းဆရာ ဆရာမင်း၊ ဈေးသည် မသီတာနဲ့ တက္ကစီဆရာ ကိုအောင်တို့ စားပွဲ ၃ မှာ အတူထိုင်နေခဲ့ကြတာပါ။",
						"သူတို့ သန်းခေါင်ယံ ဆိပ်ကမ်းကုန်စည်အကြောင်း ပြောနေတုန်း အဲဒီသူစိမ်း သူတို့ဘေး လာထိုင်တာပဲ။ သူတို့ လက်ဖက်ရည်အော်ဒါလေး ဖြေရှင်းပေးရင် သူတို့ သိတာတွေ ပြောပြကြလိမ့်မယ်ဗျ!"
					]
				}
			},
			{
				"id": "q_items",
				"text": {
					"en": "Did the stranger leave anything behind?",
					"my": "သူစိမ်း ကျန်ရစ်ခဲ့တဲ့ ပစ္စည်းများ ရှိပါသလား?"
				},
				"dialogue": {
					"en": [
						"Yes! He left a worn leather notebook on the stool, and that crinkled receipt was dropped near the counter.",
						"You should inspect them closely—a sharp detective like you will surely spot clues I overlooked!"
					],
					"my": [
						"ရှိတယ်ဗျာ! ခုံပေါ်မှာ သားရေမှတ်စုစာအုပ်တစ်အုပ် ကျန်ခဲ့ပြီး ကောင်တာအနီးမှာ တွန့်ကျေနေတဲ့ ဘေလ်ဖြတ်ပိုင်းတစ်ခု တွေ့ရတယ်။",
						"စားပွဲပေါ်မှာ သေချာစစ်ဆေးကြည့်ပါဦး—စုံထောက်ကြီးလို မျက်စိထက်တဲ့သူဆို ကျွန်တော် မမြင်တာတွေ တွေ့နိုင်မှာပါ!"
					]
				}
			}
		],
		"evidence_reactions": {
			"tea_receipt_timestamp": {
				"is_contradiction": true,
				"reveals_info": "ko_zaw_true_timeline",
				"dialogue_first": {
					"en": [
						"Wait... this tea shop receipt is stamped 11:42 PM?! (Ko Zaw turns pale and rubs his neck nervously)...",
						"Alright, Detective... you caught me. I told everyone midnight earlier because I didn't want police scrutinizing our late closing permit.",
						"The real truth is: he paid at 11:42 PM and dashed into the downpour at 11:45 PM sharp—the exact moment our wall clock jammed!",
						"Right before sprinting into the dark, he frantically asked if Ko Aung's taxi was still waiting outside on 38th Street!"
					],
					"my": [
						"နေပါဦး... ဒီလက်ဖက်ရည်ဆိုင် ဘေလ်မှာ အချိန်တံဆိပ်က ၁၁:၄၂ ပါလား?! (ကိုဇော် မျက်နှာပျက်သွားပြီး လည်ပင်းကို ပွတ်သပ်ရင်း အကြည့်လွှဲလိုက်သည်)...",
						"ကောင်းပါပြီ စုံထောက်ကြီးရယ်... ကျွန်တော် ဝန်ခံပါ့မယ်။ ဆိုင်ပိတ်ချိန်နဲ့ ပတ်သက်ပြီး ရဲတွေ စစ်ဆေးမှာစိုးလို့ စောစောက သန်းခေါင်ယံလို့ လိမ်ပြောလိုက်မိတာပါ။",
						"တကယ်တော့ သူဟာ ၁၁:၄၂ မှာ ဘေလ်ရှင်းပြီး နံရံကပ်နာရီ ရပ်သွားတဲ့ ၁၁:၄၅ အတိမှာ မိုးထဲရေထဲ ပြေးထွက်သွားခဲ့တာပါ!",
						"မပြေးခင်မှာ သူ ၃၈ လမ်းမပေါ်မှာ ကိုအောင့်တက္ကစီ ရှိမရှိ အလောတကြီး မေးသွားခဲ့ပါသေးတယ်!"
					]
				},
				"dialogue_repeated": {
					"en": [
						"I've already told you the honest truth about that receipt, Detective. 11:45 PM sharp, and he asked for Ko Aung's taxi."
					],
					"my": [
						"အဲဒီဘေလ်ဖြတ်ပိုင်းအကြောင်း အမှန်အတိုင်း ကျွန်တော် ဝန်ခံပြီးပါပြီဗျာ။ ၁၁:၄၅ အတိမှာ ကိုအောင့်တက္ကစီကို မေးပြီး ပြေးသွားတာပါ။"
					]
				}
			},
			"tea_clock_stopped_time": {
				"dialogue": {
					"en": [
						"Yes, our antique teak clock! The hands jammed at 11:45 PM right when the electrical surge flared as the stranger fled."
					],
					"my": [
						"ဟုတ်ပါတယ်ဗျာ၊ အဲဒီရှေးဟောင်းနာရီကြီး! အဲဒီလူ ပြေးထွက်သွားပြီး လျှပ်စစ်မီးတွေ ဝင်းကနဲဖြစ်ချိန် ၁၁:၄၅ မှာ လက်တံတွေ ရပ်သွားခဲ့တာပါ။"
					]
				}
			},
			"tea_notebook_cipher": {
				"dialogue": {
					"en": [
						"That leather notebook! The stranger dropped it when he bolted. I saw weird cipher symbols inside and decided not to touch it."
					],
					"my": [
						"အဲဒီသားရေစာအုပ်လား! အဲဒီလူ ပြေးတုန်းက ကျန်ခဲ့တာ။ အထဲမှာ ထူးဆန်းတဲ့ လျှို့ဝှက်ကုဒ်တွေ တွေ့လို့ ကျွန်တော် မကိုင်ရဲတာနဲ့ ထားထားတာပါ။"
					]
				}
			},
			"harbor_cargo_slip": {
				"dialogue": {
					"en": [
						"A cargo slip for Pier 4 with the Royal Hintha Seal?! That must have slipped from his raincoat pocket! He was definitely heading to the docks."
					],
					"my": [
						"ဆိပ်ခံ (၄) အတွက် ဟင်္သာတံဆိပ်ပါ ကုန်လက်မှတ်ကြီးပါလား?! သူ့မိုးကာအင်္ကျီအိတ်ထဲက ကျသွားတာ ဖြစ်မယ်! သူ ဆိပ်ကမ်းဘက်ကို သွားတာ သေချာနေပြီ။"
					]
				}
			},
			"tea_port_newspaper": {
				"dialogue": {
					"en": [
						"A newspaper article circled in red about the port? Someone left that near the kettle yesterday. Sounds like shady business down on Strand Road."
					],
					"my": [
						"ဆိပ်ကမ်းသတင်းကို အနီရောင်ဝိုင်းထားတဲ့ သတင်းစာလား? မနေ့က ရေနွေးအိုးနားမှာ တစ်ယောက်ယောက် ထားခဲ့တာပါ။ ကမ်းနားလမ်းဘက်မှာ မသင်္ကာစရာတွေ ဖြစ်နေပုံရတယ်။"
					]
				}
			},
			"default": {
				"dialogue": {
					"en": [
						"Hmm, I haven't seen that before, Detective. Doesn't seem connected to what happened here tonight."
					],
					"my": [
						"ဟင်၊ ဒါမျိုး ကျွန်တော် တစ်ခါမှ မမြင်ဖူးပါဘူး စုံထောက်ကြီး။ ဒီည ဒီမှာဖြစ်ခဲ့တာနဲ့တော့ မဆိုင်ဘူး ထင်တယ်ဗျာ။"
					]
				}
			}
		}
	}
}

static func get_character_questioning_data(char_id: String, lang: String) -> Dictionary:
	var l = lang if lang == "my" else "en"
	if CHARACTER_QUESTIONING.has(char_id):
		var raw = CHARACTER_QUESTIONING[char_id]
		var data = {}
		data["id"] = char_id
		data["speaker"] = raw.get("speaker", {}).get(l, raw.get("speaker", {}).get("en", char_id))
		
		# Greetings
		var g_raw = raw.get("greetings", {})
		data["greetings"] = {}
		for g_key in g_raw:
			data["greetings"][g_key] = g_raw[g_key].get(l, g_raw[g_key].get("en", ""))
		
		# Questions
		data["questions"] = []
		for q in raw.get("questions", []):
			var q_item = {
				"id": q.get("id", ""),
				"text": q.get("text", {}).get(l, q.get("text", {}).get("en", ""))
			}
			if q.has("dialogue"):
				q_item["dialogue"] = q["dialogue"].get(l, q["dialogue"].get("en", []))
			if q.has("dialogue_initial"):
				q_item["dialogue_initial"] = q["dialogue_initial"].get(l, q["dialogue_initial"].get("en", []))
			if q.has("dialogue_revealed"):
				q_item["dialogue_revealed"] = q["dialogue_revealed"].get(l, q["dialogue_revealed"].get("en", []))
			data["questions"].append(q_item)
		
		# Evidence reactions
		data["evidence_reactions"] = {}
		var ev_raw = raw.get("evidence_reactions", {})
		for cid in ev_raw:
			var reaction = ev_raw[cid].duplicate(true)
			if reaction.has("dialogue"):
				reaction["dialogue"] = reaction["dialogue"].get(l, reaction["dialogue"].get("en", []))
			if reaction.has("dialogue_first"):
				reaction["dialogue_first"] = reaction["dialogue_first"].get(l, reaction["dialogue_first"].get("en", []))
			if reaction.has("dialogue_repeated"):
				reaction["dialogue_repeated"] = reaction["dialogue_repeated"].get(l, reaction["dialogue_repeated"].get("en", []))
			data["evidence_reactions"][cid] = reaction
		
		return data
	return {}

