const { Task } = require('../models/Task');

// Create a new task
exports.createTask = async (req, res) => {
  try {
    const { userId, title, description, status } = req.body;

    if (!userId || !title) {
      return res.status(400).json({ message: 'userId and title are required' });
    }

    const task = new Task({
      userId,
      title,
      description,
      status
    });

    await task.save();
    res.status(201).json(task);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get all tasks for a specific user
exports.getTasks = async (req, res) => {
  try {
    const { userId } = req.query;

    if (!userId) {
      return res.status(400).json({ message: 'userId query param is required' });
    }

    const tasks = await Task.find({ userId });
    res.status(200).json(tasks);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Update a task by its ID
exports.updateTask = async (req, res) => {
  try {
    const { id, description, status } = req.body;

    if (!id) {
      return res.status(400).json({ message: 'Task ID is required' });
    }

    const updatedTask = await Task.findByIdAndUpdate(
      id,
      { description, status },
      { new: true }
    );

    if (!updatedTask) {
      return res.status(404).json({ message: 'Task not found' });
    }

    res.status(200).json(updatedTask);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
