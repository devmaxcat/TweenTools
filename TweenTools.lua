local tool = {}

TS = game:GetService('TweenService')

function tool.EasyTween(part, tweeninfo, goal) 
	TS:Create(part, tweeninfo, goal):Play()
end

function tool.FromToTween(part, tweeninfo, start, ending)
	for i,v in pairs(start) do
		part[i] = start[i]

	end

	TS:Create(part, tweeninfo, ending):Play()
end

-- Tween from goal, back to original value before tween
function tool.BackTween(part, tweeninfo, goal)
	local currentValues = {}

	for i,v in pairs(goal) do
		currentValues[i] = part[i]
		part[i] = goal[i]
		print(part[i])
	end


	TS:Create(part, tweeninfo, currentValues):Play()
end

-- Yields for the duration of the tween
function tool.YieldTween(instanceType, parent, tweeninfo, goal)
	local newInstance = Instance.new(instanceType)
	TS:Create(newInstance, tweeninfo, goal):Play()
	task.spawn(function()
		wait(tweeninfo.Time)

	end)

	return newInstance

end
-- Runs the given function after the tween is completed
function tool.CallbackTween(part, tweeninfo, goal, callback)
	local tween = TS:Create(part, tweeninfo, goal)
	tween:Play()
	tween.Completed:Connect(function()
		callback()
	end)
end
-- Tweens all children (or descendants) of an Instance of a specific type (can include the parent Instance as well)
function tool.TweenChildrenOfType(parent, tweeninfo, goal, className, recursive, includeParent)
	local c;
	if (recursive) then
		c = parent:GetDescendants()
	else
		c = parent:GetChildren()
	end
	for k,v in ipairs(c) do
		if (k == 1 and includeParent and parent:IsA(className)) then

			TS:Create(parent, tweeninfo, goal):Play()
		elseif (not parent:IsA(className) and includeParent) then
			warn('TWEENTOOLS: Parent does not match given type, skipping... Set includeParent to false to silence this warning.')

		end

		if (v:IsA(className) and v.Parent.Name ~= '_IGNORECHILDREN') then
			TS:Create(v, tweeninfo, goal):Play()
		end

	end


end

-- Not actually a Tween but was helpful if you want to combine this and the other tween methods in this module.
-- Functionally similar to TweenChildrenOfType but runs the given function with the instance passed as a parameter
function tool.FunctionChildrenOfType(parent, func, className, recursive, includeParent)
	local c;
	if (recursive) then
		c = parent:GetDescendants()
	else
		c = parent:GetChildren()
	end
	print(c)
	for k,v in ipairs(c) do
		if (k == 1 and includeParent and parent:IsA(className)) then

			func(v, k)
		elseif (not parent:IsA(className) and includeParent) then
			warn('TWEENTOOLS: Parent does not match given type, skipping... Set includeParent to false to silence this warning.')

		end

		if (v:IsA(className) and v.Parent.Name ~= '_IGNORECHILDREN') then
			func(v, k)
		end

	end
end



return tool
