const AddonsPage = {
	setup() {
		Vue.onMounted(function () {
			luaRun("UpdateAddonDisabledState()");
			addonStore.switch("subscribed", 0);
		});

		return {
			store: addonStore,
			AddonsStore,
			AddonActions,
			MenuActions,
			Subscriptions,
			t,
			num0,
			getNiceSize,
			compatState,
		};
	},
	data() {
		return {
			categories: ["trending", "popular", "latest"],
			categoriesSecondary: [
				"followed",
				"favorite",
				"friends",
				"mine",
				"downloaded_ugc",
			],
			addonTypes: [
				"gamemode",
				"map",
				"weapon",
				"tool",
				"npc",
				"entity",
				"effects",
				"vehicle",
				"model",
			],
		};
	},
	computed: {
		headerKey() {
			const s = this.store;
			return s.tagged === "" || s.tagged === "Addon"
				? "addons." + s.category
				: "addons." + s.tagged;
		},
		headerSubKey() {
			const s = this.store;
			return s.tagged === "" || s.tagged === "Addon"
				? "addons." + s.category + ".subtitle"
				: "addons." + s.tagged + ".subtitle";
		},
		presetNames() {
			return Object.values(compatState.presetList).filter(
				function (preset) {
					return (
						preset.name
							.toLowerCase()
							.indexOf(
								AddonsStore.presetSearchText.toLowerCase(),
							) !== -1
					);
				},
			);
		},
		selectedPresetData() {
			return compatState.presetList[AddonsStore.selectedPreset];
		},
	},
	methods: {
		entryClass(file) {
			return AddonActions.addonClasses(file);
		},
		entryDescription(file) {
			return AddonActions.addonDescription(file);
		},
		childTitle(fileid) {
			return compatState.childTitles[String(fileid)] || fileid;
		},
		isUninstallWarning() {
			return (
				AddonsStore.popupMessageKey === "addons.uninstallall.warning" ||
				AddonsStore.popupMessageKey ===
					"addons.uninstall_selected.warning"
			);
		},
		popupConfirmClass() {
			return AddonsStore.popupMessageFiles.length > 0
				? "create big"
				: "warning big";
		},
	},
	template: `
<div class="page">

	<div class="options">
		<ul>
			<li><h2>{{ t('addons') }}</h2></li>

			<li>
				<a :class="{ active: store.category === 'subscribed' }" @click="store.switch( 'subscribed', 0 )">{{ t('addons.subscribed') }}</a>
				<ul v-if="store.category === 'subscribed'" class="submenu">
					<li v-for="tag in addonTypes" :key="tag">
						<a @click="store.switchWithTag( 'subscribed', 0, tag )" :class="{ active: store.tagged === tag }">{{ t('addons.' + tag) }}</a>
					</li>
					<li><input type="text" class="search_bar" v-model="AddonsStore.subscriptionSearchText" @input="store.handleOnSearch()" :placeholder="t('addons.search')"/></li>
				</ul>
			</li>

			<li>&nbsp;</li>

			<li v-for="cat in categories" :key="cat">
				<a @click="store.switchWithTag( cat, 0, 'Addon' )" :class="{ active: store.category === cat }">{{ t('addons.' + cat) }}</a>
				<ul v-if="store.category === cat">
					<li v-for="tag in addonTypes" :key="cat + tag">
						<a @click="store.switchWithTag( cat, 0, tag )" :class="{ active: store.tagged === tag }">{{ t('addons.' + tag) }}</a>
					</li>
				</ul>
			</li>

			<li>&nbsp;</li>

			<li v-for="cat in categoriesSecondary" :key="'s-' + cat">
				<a @click="store.switchWithTag( cat, 0, 'Addon' )" :class="{ active: store.category === cat }">{{ t('addons.' + cat) }}</a>
				<ul v-if="store.category === cat && cat !== 'downloaded_ugc'">
					<li v-for="tag in addonTypes" :key="cat + tag">
						<a @click="store.switchWithTag( cat, 0, tag )" :class="{ active: store.tagged === tag }">{{ t('addons.' + tag) }}</a>
					</li>
				</ul>
			</li>

			<li>&nbsp;</li>

			<li><a @click="MenuActions.openWorkshop()">{{ t('addons.openworkshop') }}</a></li>
		</ul>
	</div>

	<div class="ugc_content">
		<h1 class="menuheader">
			<span>{{ t(headerKey) }}</span>
			<small>{{ t(headerSubKey) }}</small>
		</h1>

		<workshopcontainer>
			<workshopmessage v-if="store.loading">{{ t('addons.loading') }}</workshopmessage>
			<workshopmessage v-if="(store.totalResults === 0 || store.numResults === 0) && !store.loading && (!AddonsStore.disabled || store.category !== 'subscribed')">{{ t('addons.none') }}</workshopmessage>
			<workshopmessage v-if="store.totalResults === 0 && !store.loading && AddonsStore.disabled && store.category === 'subscribed'">{{ t('addons.disabled') }}</workshopmessage>

			<workshopicon v-for="file in store.files" :key="file.order" v-show="!store.loading"
				@click="AddonActions.toggleSelect( file, $event )"
				:style="{ width: Math.round(store.iconWidth) + 'px', height: Math.round(store.iconHeight) + 'px' }"
				:class="entryClass( file )">
				<preview :style="{ width: Math.round(store.iconMax) + 'px', height: Math.round(store.iconMax) + 'px', marginLeft: -Math.round(store.iconMax * 0.5) + 'px', marginTop: -Math.round(store.iconMax * 0.5) + 'px' }">
					<img :src="'../' + (file.background || 'img/downloading.png')" :style="{ width: Math.round(store.iconMax) + 'px', height: Math.round(store.iconMax) + 'px' }" loading="lazy"/>
					<disabled></disabled>
				</preview>

				<name :class="{ subscription: store.category === 'subscribed' }">
					<label @click="MenuActions.openWorkshopFile( file.id )">{{ file.extra.title || file.info.title }}
						<span v-if="!file.extra.title && !file.info.title">{{ t('ugc.loading') }}</span>
					</label>
				</name>
				<author v-if="!file.local">{{ file.info.ownername }}<span v-if="!file.info.ownername">{{ t('ugc.loading') }}</span></author>
				<size v-if="file.info.size">{{ getNiceSize( file.info.size ) }}</size>
				<votes v-if="!file.local && (file.info.up - file.info.down) > 0">+{{ num0(file.info.up - file.info.down) }}</votes>
				<votes v-if="!file.local && (file.info.up - file.info.down) < 0" class="negative">{{ num0(file.info.up - file.info.down) }}</votes>
				<description>{{ entryDescription( file ) }}</description>
				<input type="checkbox" class="checkbox" v-if="store.category === 'subscribed' && !(file.info && file.info.floating)" v-model="AddonsStore.selectedItems[file.id]" />

				<controls v-if="!(file.info && file.info.floating)">
					<left>
						<control :class="{ disabled: file.info.voted_up }" v-if="!file.local" @click.stop="store.rate( file, true )"><img src='img/thumb-up.png' loading="lazy"/></control>
						<control :class="{ disabled: file.info.voted_down }" v-if="!file.local" @click.stop="store.rate( file, false )"><img src='img/thumb-down.png' loading="lazy"/></control>
						<control v-if="!file.local && !file.info.favorite" @click.stop="store.favorite( file, true )"><img src='img/favourite_addon.png' loading="lazy"/></control>
						<control v-if="!file.local && file.info.favorite" @click.stop="store.favorite( file, false )"><img src='img/favourite_addon_remove.png' loading="lazy"/></control>
					</left>

					<right>
						<control v-if="AddonActions.isSubscribed( file ) && AddonActions.isEnabled( file )" @click.stop="AddonActions.disable( file )">{{ t('addon.disable') }}</control>
						<control v-if="AddonActions.isSubscribed( file ) && !AddonActions.isEnabled( file )" @click.stop="AddonActions.enable( file )">{{ t('addon.enable') }}</control>
						<control v-if="!AddonActions.isSubscribed( file )" @click.stop="AddonActions.subscribe( file )">{{ t('addon.subscribe') }}</control>
						<control v-if="AddonActions.isSubscribed( file )" @click.stop="AddonActions.unsubscribe( file )">{{ t('addon.unsubscribe') }}</control>
						<control v-if="store.category === 'downloaded_ugc'" @click.stop="AddonActions.markUnused( file )">{{ t('addon.mark_unused') }}</control>
					</right>
				</controls>
			</workshopicon>
		</workshopcontainer>

		<center>
			<WbPagination :store="store"></WbPagination>
		</center>

		<a v-if="store.category === 'subscribed'" class="ugc_settings_button" @click="AddonsStore.settingsOpen = !AddonsStore.settingsOpen">
			<img src="img/settings.png">
		</a>

		<div v-if="store.category === 'subscribed'" class="ugc_settings" :class="AddonsStore.settingsOpen ? 'active' : 'hidden'">
			<div class="ugc_settings_cat">
				<span>{{ t('addons.filter_by') }}</span>
				<input type="checkbox" v-model="AddonsStore.filterEnabledOnly" @change="store.handleFilterChange( 1 )" id="FilterEnabledOnly"/><label for="FilterEnabledOnly">{{ t('addons.enabled_only') }}</label><br/>
				<input type="checkbox" v-model="AddonsStore.filterDisabledOnly" @change="store.handleFilterChange( 0 )" id="FilterDisabledOnly"/><label for="FilterDisabledOnly">{{ t('addons.disabled_only') }}</label>
			</div>
			<div class="ugc_settings_cat">
				<span>{{ t('addons.sort_by') }}</span>
				<input type="radio" name="sort" value="title" v-model="AddonsStore.ugcSortMethod" @change="store.handleSortChange()" id="UGCSortMethod_title"/><label for="UGCSortMethod_title">{{ t('addons.name') }}</label><br/>
				<input type="radio" name="sort" value="size" v-model="AddonsStore.ugcSortMethod" @change="store.handleSortChange()" id="UGCSortMethod_size"/><label for="UGCSortMethod_size">{{ t('addons.size') }}</label><br/>
				<input type="radio" name="sort" value="updated" v-model="AddonsStore.ugcSortMethod" @change="store.handleSortChange()" id="UGCSortMethod_updated"/><label for="UGCSortMethod_updated">{{ t('addons.update_date') }}</label><br/>
				<input type="radio" name="sort" value="subscribed" v-model="AddonsStore.ugcSortMethod" @change="store.handleSortChange()" id="UGCSortMethod_subscribed"/><label for="UGCSortMethod_subscribed">{{ t('addons.sub_date') }}</label>
			</div>
			<div class="ugc_settings_cat">
				<div v-if="!AddonActions.isAnySelected()">
					<a @click="AddonActions.selectAll()">{{ t('addons.selectall') }}</a>
					<a @click="AddonActions.selectAllPage()">{{ t('addons.selectpage') }}</a>
					<a @click="AddonActions.displayPopupMessage( 'addons.enableall.warning', () => AddonActions.enableAllSubscribed() )">{{ t('addons.enableall') }}</a>
					<a @click="AddonActions.displayPopupMessage( 'addons.disableall.warning', () => AddonActions.disableAllSubscribed() )">{{ t('addons.disableall') }}</a>
					<a @click="AddonActions.displayPopupMessage( 'addons.uninstallall.warning', () => AddonActions.uninstallAllSubscribed() )">{{ t('addons.uninstallall') }}</a>
				</div>
				<div v-else>
					<a @click="AddonActions.unselectAll()">{{ t('addons.unselectall') }}</a>
					<a @click="AddonActions.selectAllPage()">{{ t('addons.selectpage') }}</a>
					<a @click="AddonActions.enableAllSelected();">{{ t('addons.enable_selected') }}</a>
					<a @click="AddonActions.disableAllSelected();">{{ t('addons.disable_selected') }}</a>
					<a @click="AddonActions.displayPopupMessage( 'addons.uninstall_selected.warning', () => AddonActions.uninstallAllSelected() )">{{ t('addons.uninstall_selected') }}</a>
				</div>
			</div>
			<div class="ugc_settings_cat">
				<a @click="AddonActions.openCreatePresetMenu()">{{ t('addons.create_preset') }}</a>
				<a @click="AddonActions.openLoadPresetMenu()">{{ t('addons.load_preset') }}</a>
				<a @click="AddonActions.openImportPresetMenu()">{{ t('addons.import_preset') }}</a>
			</div>
			<div class="ugc_settings_cat">
				<span><font>{{ t('addons.total_subscriptions') }}</font> {{ AddonActions.getSubscribedCount() }}</span>
				<span><font>{{ t('addons.total_selected') }}</font> {{ AddonActions.getSelectedCount() }}</span>
			</div>
		</div>
	</div>

	<div class="modaldialog" v-if="AddonsStore.createPresetOpen">
		<div class="centermessage left create_preset">
			<b>{{ t('addons.create_preset') }}</b>
			<br/><br/>
			<input type="text" class="preset_name" v-model="AddonsStore.presetName" :placeholder="t('addons.preset_name_placeholder')"/><br/>
			<br/>
			<input type="checkbox" v-model="AddonsStore.saveEnabled" id="CreatePresetSaveEnabled"/><label for="CreatePresetSaveEnabled">{{ t('addons.preset_save_enabled') }}</label><br/>
			<input type="checkbox" v-model="AddonsStore.saveDisabled" id="CreatePresetSaveDisabled"/><label for="CreatePresetSaveDisabled">{{ t('addons.preset_save_disabled') }}</label><br/>
			<br/>
			<b>{{ t('addons.preset_new_action') }}</b><br/>
			<input type="radio" name="createpreset_newitems" value="" v-model="AddonsStore.presetNewAction" id="cp_nothing"/><label for="cp_nothing">{{ t('addons.action_nothing') }}</label><br/>
			<input type="radio" name="createpreset_newitems" value="disable" v-model="AddonsStore.presetNewAction" id="cp_disable"/><label for="cp_disable">{{ t('addons.action_disable') }}</label><br/>
			<input type="radio" name="createpreset_newitems" value="enable" v-model="AddonsStore.presetNewAction" id="cp_enable"/><label for="cp_enable">{{ t('addons.action_enable') }}</label><br/>
			<br/>
			<a @click="AddonActions.createNewPreset()" :class="{ disabled: AddonsStore.presetName === '' }" class="create big">{{ t('addons.create_preset') }}</a>
			<hr>
			<a @click="AddonActions.closePopupMessage()">{{ t('addons.cancel') }}</a>
		</div>
	</div>

	<div class="modaldialog" v-if="AddonsStore.importPresetOpen">
		<div class="centermessage left create_preset">
			<b>{{ t('addons.import_preset') }}</b>
			<br/><br/>
			<input type="text" class="preset_name" v-model="AddonsStore.importSource" :placeholder="t('addons.preset_source')"/><br/>
			<br/><br/>
			<input type="text" class="preset_name" v-model="AddonsStore.presetName" :placeholder="t('addons.preset_name_placeholder')"/><br/>
			<br/>
			<b>{{ t('addons.preset_new_action') }}</b><br/>
			<input type="radio" name="importpreset_newitems" value="" v-model="AddonsStore.presetNewAction" id="ip_nothing"/><label for="ip_nothing">{{ t('addons.action_nothing') }}</label><br/>
			<input type="radio" name="importpreset_newitems" value="disable" v-model="AddonsStore.presetNewAction" id="ip_disable"/><label for="ip_disable">{{ t('addons.action_disable') }}</label><br/>
			<input type="radio" name="importpreset_newitems" value="enable" v-model="AddonsStore.presetNewAction" id="ip_enable"/><label for="ip_enable">{{ t('addons.action_enable') }}</label><br/>
			<br/>
			<a @click="AddonActions.importPreset()" :class="{ disabled: AddonsStore.importSource === '' || AddonsStore.presetName === '' }">{{ t('addons.import_preset') }}</a>
			<hr>
			<a @click="AddonActions.closePopupMessage()">{{ t('addons.cancel') }}</a>
		</div>
	</div>

	<div class="modaldialog" v-if="AddonsStore.importPresetLoading">
		<div class="centermessage left create_preset">
			<h1>{{ t('dupes.loading') }}</h1>
		</div>
	</div>

	<div class="modaldialog" v-if="AddonsStore.loadPresetMenuOpen">
		<div class="centermessage left">
			<b>{{ t('addons.load_preset') }}</b>
			<br/><br/>

			<div class="preset_content">
				<div class="preset_side">
					<input type="text" v-model="AddonsStore.presetSearchText" :placeholder="t('addons.filter_preset')"/>
					<div class="preset_list">
						<font v-for="preset in presetNames" :key="preset.name" @click="AddonActions.selectPreset( preset.name, preset.newAction );" :class="{ active: preset.name === AddonsStore.selectedPreset }">{{ preset.name }}</font>
					</div>
				</div>
				<div class="preset_data" v-if="selectedPresetData">
					<b>{{ t('addons.preset_name') }}</b> {{ selectedPresetData.name }}<br/>
					<b>{{ t('addons.preset_enabled') }}</b> {{ selectedPresetData.enabled.length }}<br/>
					<b>{{ t('addons.preset_disabled') }}</b> {{ selectedPresetData.disabled.length }}<br/>
					<input type="checkbox" v-model="AddonsStore.loadPresetResub" id="LoadPresetResub"/><label for="LoadPresetResub">{{ t('addons.preset_resub_missing') }}</label><br/>

					<br><b>{{ t('addons.preset_new_action') }}</b><br>
					<input type="radio" name="loadpreset_newitems" value="" v-model="AddonsStore.presetNewAction" id="lp_nothing"/><label for="lp_nothing">{{ t('addons.action_nothing') }}</label><br/>
					<input type="radio" name="loadpreset_newitems" value="disable" v-model="AddonsStore.presetNewAction" id="lp_disable"/><label for="lp_disable">{{ t('addons.action_disable') }}</label><br/>
					<input type="radio" name="loadpreset_newitems" value="enable" v-model="AddonsStore.presetNewAction" id="lp_enable"/><label for="lp_enable">{{ t('addons.action_enable') }}</label><br/>

					<br>
					<a @click="AddonActions.loadSelectedPreset()" class="create">{{ t('addons.load_preset') }}</a>
					<a @click="AddonActions.copySelectedPreset()">{{ t('addons.copy_preset') }}</a>
					<br><br>
					<a @click="AddonActions.deletePreset( AddonsStore.selectedPreset )" class="warning">{{ t('addons.delete_preset') }}</a>
				</div>
			</div>

			<a @click="AddonActions.closePopupMessage()">{{ t('addons.cancel') }}</a>
		</div>
	</div>

	<div class="modaldialog" v-if="AddonsStore.popupMessage">
		<div class="centermessage">
			<span>{{ t('addons.warning') }}</span>
			<span>{{ t(AddonsStore.popupMessageKey) }}</span>
			<span v-if="isUninstallWarning()">{{ t('addons.cannotundo') }}</span>

			<div style="margin-bottom: 5px;">
				<div v-for="fileid in AddonsStore.popupMessageFiles" :key="fileid" class="button" :class="{ subbed: AddonActions.isSubscribedID( fileid ) }">
					<wstitle @click="MenuActions.openWorkshopFile( fileid )" class="wstitle">{{ childTitle( fileid ) }}</wstitle>
					<wsbut v-if="AddonActions.isSubscribedID( fileid )" class="wssub"><img src="img/tick.png" loading="lazy"/></wsbut>
					<wsbut v-else @click="Subscriptions.subscribe( fileid )" class="wssub"><img src="img/plus.png"></wsbut>
				</div>
			</div>

			<a @click="AddonActions.executePopupAction()" :class="popupConfirmClass()">{{ t('addons.confirm') }}</a>
			<a @click="AddonActions.closePopupMessage( true )" v-if="AddonsStore.popupAction != null">{{ t('addons.cancel') }}</a>
		</div>
	</div>

</div>`,
};
