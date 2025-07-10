const { default: mongoose, mongo } = require("mongoose");
const { User } = require("./User");

/**
 * User Model - Authentication Schema
 * 
 * Core fields for authentication:
 * - userId: Unique identifier
 * - password: For storing hashed credentials
 * 
 * For production: Consider adding email, timestamps, roles, and personal info
 */

const taskSchema = new mongoose.Schema(
    {
        userId : {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true,            
            trim: true
            
        },
        title : {
            type: String,
            default: '',
            trim: true,
            required : true,
            
        },
        description : {
            type: String,
            default: '',
            trim: true,
            
        },
        status : {
            type: String,
            enum: ['pending', 'completed'],
            default: 'pending',
            
            
        },
        date : {
            type : Date,
            default : Date.now
            
            
        },
    }
)


const Task = mongoose.model("Task", taskSchema)
module.exports = {Task };