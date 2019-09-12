/*
 * Copyright 2017 The PIONUX OS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef PIONUX_LXCCONTAINER_MANAGER_H
#define PIONUX_LXCCONTAINER_MANAGER_H

#include "ContainerManager.h"

namespace android
{

class LXCContainerManager : public ContainerManager
{
public:
    LXCContainerManager();

    // ContainerManager interface
    // ------------------------------------------------------------------------

    virtual bool start(const char *id);
    virtual bool stop(const char *id);
    virtual bool isRunning(const char *id);
    virtual bool enableInput(const char *id, const bool enable);

    // ------------------------------------------------------------------------

protected:
    // we are reference counted
    virtual ~LXCContainerManager();
};

}; // namespace android

#endif // PIONUX_LXCCONTAINER_MANAGER_H
