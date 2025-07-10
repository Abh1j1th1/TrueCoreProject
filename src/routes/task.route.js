const express = require('express');
const Taskrouter = express.Router();
const taskController = require('../controllers/task.controller');


Taskrouter.post('/create', taskController.createTask);


Taskrouter.get('/all', taskController.getTasks);


Taskrouter.put('/update', taskController.updateTask);

module.exports = Taskrouter;