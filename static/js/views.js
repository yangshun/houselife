
$(function () {

    $( "#tabs" ).tabs();

    TaskView = Backbone.View.extend({
        model: Task,
        initialize: function (completed) {
            var thisView = this;
            if (this.model instanceof Task) {
                if (this.model.get('status') < 1) {
                    this.renderNormalView(true,true,true);
                }
            }

            this.model.on('change', function (model) {
                if (model.get('status') == 1) {
                    thisView.$el.remove();
                }
            });
        },
        renderNormalView: function (completeButton,editButton,deleteButton) {

            var thisView = this;

            this.viewType = 'normal';

            var $tableRow = $('<tr>');


            var $descriptionEntry = $('<td>');
            $descriptionEntry.html(this.model.get('description'));
            var $titleEntry = $('<td>');
            $titleEntry.html(this.model.get('title'));
            
            var $assigneeEntry = $('<td style="text-align:center;">');
            var user = appVars.household.find(
                function (user) {
                    return user.get('objectId') == thisView.model.get('assignee_id');
                }
            );

            if (user) {
                $assigneeEntry.html('<img style="height:30px; width:30px;" src="/static/img/thumb/'+user.get('username')+'.png" />');
            }

            var $editEntry = $('<td>');
            if (editButton) {
                var $editButton = $('<i class="icon-pencil icon-gray pointer"></i>');
                $editButton.click(function () {
                    thisView.renderEditView();
                });
                $editEntry.append($editButton);                
            }


            var $completeEntry = $('<td>');

            if (completeButton) {
                var $completeButton = $('<i class="icon-ok icon-gray pointer"></i>');
                $completeButton.click(function () {
                    thisView.model.set('status',1);
                    thisView.model.save();
                });
                $completeEntry.append($completeButton);
            }

            var $deleteEntry = $('<td>');
            if (deleteButton) {
                var $deleteButton = $('<i class="icon-remove icon-gray pointer"></i>');
                $deleteButton.click(function () {
                    thisView.model.destroy({
                        wait:true
                    });
                });
                $deleteEntry.append($deleteButton);
            }

            $tableRow
                .append($titleEntry)
                .append($descriptionEntry)
                .append($assigneeEntry)
                .append($completeEntry)
                .append($editEntry)
                .append($deleteEntry);

            this.$el.replaceWith($tableRow);
            this.setElement($tableRow);
            return $tableRow;
        },

        renderEditView: function (create) {
            var thisView = this;

            this.viewType = 'edit';

            var $tableRow = $('<tr>');


            var $descriptionEntry = $('<td>');
            var $descriptionInput = $('<input>');
            $descriptionInput
                .val(this.model.get('description'))
                .on('change', function () {
                    thisView.model.set('description', $(this).val());
                })
                .appendTo($descriptionEntry);
            var $titleEntry = $('<td>');
            var $titleInput = $('<input>');
            $titleInput
                .val(this.model.get('title'))
                .on('change', function () {
                    thisView.model.set('title', $(this).val());
                })
                .appendTo($titleEntry);


            var $assigneeEntry = $('<td>');

            var $assigneeSelect = $('<select>');

            var selectedUser = appVars.household.find(
                function (user) {
                    return user.get('objectId') == thisView.model.get('assignee_id');
                }
            );

            $assigneeSelect.append($('<option value="None">None</option>'));

            appVars.household.each(function (user) {
                if (selectedUser && selectedUser.cid == user.cid) {
                    $assigneeSelect.append($('<option selected value='+user.get('objectId')+'>'+user.get('username')+'</option>'));
                } else {
                    $assigneeSelect.append($('<option value='+user.get('objectId')+'>'+user.get('username')+'</option>'));
                }
            });

            $assigneeSelect
                .on('change', function () {
                    thisView.model.set('assignee_id', $(this).val());
                })
                .appendTo($assigneeEntry);


            var $saveEntry = $('<td>');
            var $saveButton = $('<i class="icon-file icon-gray pointer"></i>');
            $saveButton.click(function () {
                thisView.renderNormalView(true, true, true);
                thisView.model.save({
                    success: function () {
                        alert("save success!");
                    }
                });
            });
            $saveEntry.append($saveButton);

            var $deleteEntry = $('<td>');
            var $deleteButton = $('<i class="icon-remove icon-gray pointer"></i>');
            $deleteEntry.append($deleteButton);

            var $emptyEntry = $('<td>');
            $tableRow
                .append($titleEntry)
                .append($descriptionEntry)
                .append($assigneeEntry)
                .append($emptyEntry)
                .append($saveEntry)
                .append($deleteEntry);

            this.$el.replaceWith($tableRow);
            this.setElement($tableRow);
            return $tableRow;
        }

    });

    CompletedTaskView = TaskView.extend({
        initialize: function () {
            var thisView = this;
            if (this.model instanceof Task) {
                if (this.model.get('status') == 1) {
                    this.renderNormalView(false,false,false);
                }
            }
        }
    });

    DeletedTaskView = TaskView.extend({
        initialize: function () {
            var thisView = this;
            if (this.model instanceof Task) {
                if (this.model.get('status') == 2) {
                    this.renderNormalView(false,false,false);
                }
            }
        }
    });

    

    TaskCollectionView = Backbone.View.extend({
        collection: TaskCollection,
        subView: TaskView,
        initialize: function () {
            var taskViews = this.taskViews = {};

            var thisCollectionView = this;

            var addView = function (model) {
                newTaskView = new thisCollectionView.subView({
                    'model': model
                });

                taskViews[model.cid] = newTaskView;

                thisCollectionView.$el.append(newTaskView.$el);
            };

            this.collection.on('add', addView);

            this.collection.on('remove', function (model) {
                taskViews[model.cid].remove();
            });

            this.collection.on('reset', function (collection) {
                for (var i in taskViews) {
                    taskViews[i].remove();
                }

                for (var j = 0; j < collection.models.length; j++) {
                    var collectionModel = collection.models[j];
                    addView(collectionModel);
                }
            });

            // Initialize this DOM element

            var $table = $('<table>');
            $table.addClass('table table-striped');
            var $tableRow = $('<tr>');
            $table.append($tableRow);

            var headers = ["Title", "Description", "<center>Assignee</center>", " ", " ", " "];

            for (var i = 0; i < headers.length; i++) {
                $tableRow.append($('<th>'+headers[i]+'</th>'));
            }

            this.setElement($table);

            
        }
    });

    CompletedTaskCollectionView = TaskCollectionView.extend({
        collection: TaskCollection,
        subView: CompletedTaskView
    });

    DeletedTaskCollectionView = TaskCollectionView.extend({
        collection: TaskCollection,
        subView: DeletedTaskView
    });


    ModalEditView = Backbone.View.extend({
        el: $('#dialog-modal'),
        model: Task,
        initialize: function () {
            var thisView = this;
            var thumbs = [];
            var selected;

            appVars.household.each(function (user) {
                var img = $('<img class="thumb" src="/static/img/thumb/'+user.get('username').toLowerCase()+'.png"/>');
                thumbs.push(img);
                img
                    .appendTo($('#new-task-assignees'))
                    .click(function () {
                        thumbs.forEach(function (img) {
                            img.removeClass('selected');
                        });
                        $(this).addClass('selected');
                        selected = user;

                    });
            });

            $('#create-task-btn').click(function () {
                var newTask = new Task({
                    "household_id": appVars.user.get('household_id'),
                    "title": $('#dialog-title-input').val(),
                    "description": $('#dialog-description-input').val(),
                    "assignee_id": selected.get('objectId'),
                    "status": 0
                });
                newTask.save();
                taskCollection.add(newTask);
                thisView.$el.dialog('close');
            });
        }
    });
});

