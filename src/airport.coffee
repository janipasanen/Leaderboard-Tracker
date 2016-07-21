makeModel = ->
	Ext.define("Airport",
		extend: "Ext.data.Model",
		fields:[
		{name: "airport"}
		{name: "city"}
		{name: "country"}
		{name: "name"}
		]
	)
	
makeStore = ->
	model = makeModel()
	store = Ext.create("Ext.data.Store",
		autoLoad : true
		autoSync : true
		model 	 : model
		proxy 	 :
			type : "rest"
			url : "airports.yaws" # Will need to change the backend here
			reader :
				type: "json"
				root: "data"
			writer:
				type: "json"
	)
	
setupAirports = ->
	store = makeStore()
	rowEditing = Ext.create "Ext.grid.plugin.RowEditing"
	grid = Ext.create "Ext.grid.Panel"
			renderTo : document.body
		   	plugins : [rowEditing]
			width : 500
			height : 300
			title : "Airports"
			store : store
			columns:
					[
						{
							text : 'Airport',
							width : 60
							sortable : true
							dataIndex : "airport"
							editor : {allowBlank: false}
					}
					{
							text : "City"
							dataIndex : "city"
							sortable : true
							editor : {allowBlank: false}
					}
					{
							text : "Country"
							dataIndex : "country"
							sortable : true
							editor : {allowBlank: false}
					}
					{
							text : "Airport Name"
							dataIndex : "name"
							sortable : true
							editor : {allowBlank: false}
					}
					]
	dockedItems:
			[
				xtype: "toolbar"
				items:
					[
						{
							text: "Add"
							handler: ->
								store.insert(0, new Airport())
									rowEditing.startEdit(0,0)
					}
					{
							itemId: 'delete'
							text: "Delete"
							handler: () ->
								selection = grid
									.getView()
									.getSelectionModel()
									.getSelection()[0]
								if(selection)
									store.remove(selection)
					}
				]
			]
Ext.onReady setupAirports